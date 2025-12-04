#!/bin/bash
set -e

# Load .env
if [ -f .env ]; then
    echo "📁 Loading environment variables from .env..."
    set -a
    source .env
    set +a
fi

REGISTRY="${GITHUB_REGISTRY:-ghcr.io}"
USERNAME="${GITHUB_USERNAME:-}"
IMAGE_NAME="${IMAGE_NAME:-prometheus-alpine}"
DOCKERFILE_VERSION=$(grep "PROMETHEUS_VERSION=" Dockerfile | cut -d'=' -f2)

# Check USERNAME
if [ -z "$USERNAME" ]; then
    echo "❌ Error: GITHUB_USERNAME not set"
    echo ""
    echo "Choose one of the following:"
    echo ""
    echo "  Option 1 (recommended): create .env file"
    echo "    cp .env.example .env"
    echo "    edit .env and add your GitHub username"
    echo ""
    echo "  Option 2: export environment variable"
    echo "    export GITHUB_USERNAME=your_github_username"
    echo "    ./build-push.sh"
    exit 1
fi

# Full image name
IMAGE="${REGISTRY}/${USERNAME}/${IMAGE_NAME}"

echo "🔨 Building image: ${IMAGE}"
echo "📌 Version: ${DOCKERFILE_VERSION}"

# Build
docker build -t "${IMAGE}:latest" \
             -t "${IMAGE}:${DOCKERFILE_VERSION}" .

echo "✅ Image build completed!"

echo "🔑 Checking Docker login status..."
if ! docker info | grep -q "Username"; then
    echo "❌ Not logged in to Docker registry. Please run:"
    echo "   docker login ghcr.io"
    exit 1
fi

echo "🚀 Pushing images..."

# Push
docker push "${IMAGE}:latest"
docker push "${IMAGE}:${DOCKERFILE_VERSION}"

echo "✅ Images pushed!"
echo ""
echo "📦 Image URLs:"
echo "  ${IMAGE}:latest"
echo "  ${IMAGE}:${DOCKERFILE_VERSION}"