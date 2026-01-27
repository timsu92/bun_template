# syntax=docker/dockerfile:1.17-labs

FROM oven/bun:alpine AS prod
ARG PROJECT_PATH
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
WORKDIR ${PROJECT_PATH}

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production

# COPY --exclude=.devcontainer/ --chown=${NONROOT_USERNAME}:${NONROOT_USERNAME} <some config>
# RUN bun run <some setup command>
COPY --exclude=.devcontainer/ --chown=${NONROOT_USERNAME}:${NONROOT_USERNAME} . .

# ENTRYPOINT ["bun", "run", "start"]

################################################################################

FROM ubuntu:noble AS dev
ARG PROJECT_PATH
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

RUN curl -fsSL https://bun.sh/install | bash

WORKDIR ${PROJECT_PATH}

CMD ["/bin/sh", "-c", "echo \"Container started\"; trap \"echo Container stopped; exit 0\" 15; exec \"$@\"; while sleep 1 & wait $!; do :; done"]
