# Bun Template (Docker Compose + Dev Containers)

This is a **Bun-first** project template that comes with:

- **Production image**: based on `oven/bun:alpine` (small, deployment-friendly)
- **Dev container**: based on Ubuntu (easy tooling, works well with VS Code Dev Containers)
- Default timezone: `Asia/Taipei`

> This repository provides the containerized development/deployment skeleton. What your service actually runs (e.g. `bun run start`) depends on your project. Remember to adjust your `package.json` scripts and the Dockerfile ENTRYPOINT accordingly.

## Features

- Bun
- Ubuntu 24.04
- Git, vim, wget, curl, unzip
- Timezone: `Asia/Taipei`

## Things to change before using

Before using this template, you may want to change the project name:

- [.devcontainer/devcontainer.json line 3](./.devcontainer/devcontainer.json#L3)

...and you may want to change the timezone:

- [docker-compose.yml line 5](./docker-compose.yml#L5)
- [docker-compose.yml line 13](./docker-compose.yml#L13)
- [.devcontainer/docker-compose-dev.yml line 5](./.devcontainer/docker-compose-dev.yml#L5)
- [.devcontainer/docker-compose-dev.yml line 13](./.devcontainer/docker-compose-dev.yml#L13)

## Usage

### Development (VS Code Dev Containers)

1. Install the VS Code [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
2. Open this project in VS Code.
3. Run `Dev Containers: Reopen in Container`.

After the container starts, init your Bun project and start coding!


By default, devcontainer uses the upstream prebuilt image:

- `ghcr.io/timsu92/bun_template:main`

It still keeps the compose-based workflow (volumes, GPU settings, environment variables), but avoids rebuilding the dev image in every consumer project.

If you want to test Dockerfile changes locally (maintainer mode), temporarily switch [.devcontainer/devcontainer.json](./.devcontainer/devcontainer.json) to:

```jsonc
"dockerComposeFile": ["docker-compose-dev.yml", "docker-compose-dev.build.yml"]
```

Then run `Rebuild Container`.

### Auto publish dev image

GitHub Actions workflow [.github/workflows/publish-dev-image.yml](./.github/workflows/publish-dev-image.yml) builds the `dev` stage and publishes to GHCR when relevant files change:

- `.devcontainer/**`
- `.dockerignore`
- `docker-compose.yml`
- `Dockerfile`
- `.github/workflows/publish-dev-image.yml`

It also runs on:

- manual trigger (`workflow_dispatch`)
- weekly schedule: Sunday 03:00 Asia/Taipei

Fork repositories do not push images by default, and will consume the upstream image unless explicitly changed.

## Deployment / Production (Docker Compose)

The production build uses the `prod` stage in `Dockerfile` (based on `oven/bun:alpine`) and runs:

- `bun install --frozen-lockfile --production`

So your project root should include at least:

- `package.json`
- `bun.lock` or `bun.lockb` (depending on your Bun version/config)

Build and run:

```sh
docker compose up --build
```

> Note: the Dockerfile ENTRYPOINT (`["bun", "run", "start"]`) is currently commented out. To actually start your service, enable it or replace it with the command you want.
