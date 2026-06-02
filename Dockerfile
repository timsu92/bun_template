# syntax=docker/dockerfile:1.17-labs

FROM oven/bun:alpine AS prod
ARG NONROOT_USERNAME=nonroot

ENV \
    # ts
    NODE_ENV=production

ARG TZ
ENV TZ=${TZ}
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/TZ \
    && apk del tzdata

RUN addgroup -S ${NONROOT_USERNAME} \
    && adduser -S -G ${NONROOT_USERNAME} -h /home/${NONROOT_USERNAME} ${NONROOT_USERNAME}
USER ${NONROOT_USERNAME}
ARG PROJECT_PATH
WORKDIR ${PROJECT_PATH}

COPY package.json bun.lock ./
RUN --mount=type=secret,id=GITHUB_TOKEN,required=true,uid=1000,gid=1000 \
    bun install --frozen-lockfile --production

# COPY --exclude=.devcontainer/ --chown=${NONROOT_USERNAME}:${NONROOT_USERNAME} <some config>
# RUN bun run <some setup command>
COPY --exclude=.devcontainer/ --chown=${NONROOT_USERNAME}:${NONROOT_USERNAME} . .

# ENTRYPOINT ["bun", "run", "start"]

################################################################################

FROM ubuntu:noble AS dev
ARG NONROOT_USERNAME=nonroot

ENV \
    # bun
    BUN_INSTALL_CACHE_DIR="/root/.bun/install/cache"

ARG TZ
ENV TZ=${TZ}
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install --no-install-recommends -y \
        # timezone
        tzdata \
        # bun
        curl unzip \
        # useful tools
        git vim wget curl ca-certificates less
# set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN curl -fsSL https://bun.com/install | bash -s "bun-v1.3.14"

# Initialize user environment
ARG ENV_SETUP_REPO=https://github.com/timsu92/env_setup.git
ARG ENV_SETUP_REF=main
RUN --mount=type=tmpfs,dst=/tmp/dotfiles \
    git -C /tmp/dotfiles init \
    && git -C /tmp/dotfiles remote add origin ${ENV_SETUP_REPO} \
    && git -C /tmp/dotfiles fetch --depth=1 origin ${ENV_SETUP_REF} \
    && git -C /tmp/dotfiles checkout --detach FETCH_HEAD \
    && /tmp/dotfiles/bin/setup-devcontainer

ARG PROJECT_PATH
WORKDIR ${PROJECT_PATH}

CMD ["/bin/sh", "-c", "echo \"Container started\"; trap \"echo Container stopped; exit 0\" 15; exec \"$@\"; while sleep 1 & wait $!; do :; done"]
