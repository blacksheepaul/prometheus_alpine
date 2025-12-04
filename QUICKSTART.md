# Quick Start

## 1. Initialize after cloning the project

```bash
# Copy the environment-variable template
cp .env.example .env

# Edit .env and fill in your GitHub username
nano .env
# or open it with VS Code
code .env
```

## 2. Configure the file

Edit `.env`:

```bash
GITHUB_USERNAME=your_github_username
GITHUB_REGISTRY=ghcr.io
IMAGE_NAME=prometheus-alpine
```

## 3. Log in to GitHub Container Registry

```bash
docker login ghcr.io -u YOUR_USERNAME
# Enter your GitHub Personal Access Token as the password
```

## 4. Build and push the image

```bash
# Use the script to build and push automatically
./build-push.sh
```

## 5. Verify the push succeeded

```bash
docker pull ghcr.io/YOUR_USERNAME/prometheus-alpine:latest
```

---

## Environment variables

| Variable          | Description        | Default             |
| ----------------- | ------------------ | ------------------- |
| `GITHUB_USERNAME` | Your GitHub handle | Required            |
| `GITHUB_REGISTRY` | Registry endpoint  | `ghcr.io`           |
| `IMAGE_NAME`      | Image name         | `prometheus-alpine` |

## FAQ

### Q: Where is the token stored?

A: After `docker login` it is saved in the local credential store (osxkeychain on macOS).

### Q: Will the `.env` file be uploaded?

A: No, `.env` is listed in `.gitignore`.

### Q: How do I reset `.env`?

A:

```bash
rm .env
cp .env.example .env
# edit again
```
