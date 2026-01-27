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

Before using this template, you may want to change the project path in these files:

- [docker-compose.yml line 4](./docker-compose.yml#L4)
- [docker-compose.yml line 12](./docker-compose.yml#L12)
- [.devcontainer/docker-compose-dev.yml line 4](./.devcontainer/docker-compose-dev.yml#L4)
- [.devcontainer/docker-compose-dev.yml line 12](./.devcontainer/docker-compose-dev.yml#L12)
- [.devcontainer/docker-compose-dev.yml line 15](./.devcontainer/docker-compose-dev.yml#L15)
- [.devcontainer/devcontainer.json line 3](./.devcontainer/devcontainer.json#L3)
- [.devcontainer/devcontainer.json line 12](./.devcontainer/devcontainer.json#L12)

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
