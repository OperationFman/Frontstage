FROM node:20-bookworm AS build

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

WORKDIR /backstage

COPY backstage/package.json backstage/yarn.lock ./
COPY backstage/packages packages/
COPY backstage/plugins plugins/
COPY backstage/.yarn .yarn/
COPY backstage/.yarnrc.yml ./.yarnrc.yml

RUN yarn install --immutable
RUN yarn build:backend

FROM node:20-bookworm-slim AS final

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

WORKDIR /backstage

ENV NODE_OPTIONS="--no-node-snapshot"

COPY --from=build /backstage/.yarn ./.yarn
COPY --from=build /backstage/.yarnrc.yml ./.yarnrc.yml
COPY backstage/backstage.json ./
COPY --from=build /backstage/package.json ./
COPY --from=build /backstage/yarn.lock ./
COPY --from=build /backstage/packages/backend/dist/skeleton.tar.gz ./

RUN tar xzf skeleton.tar.gz && rm skeleton.tar.gz
RUN yarn workspaces focus --all --production

COPY --from=build /backstage/packages/backend/dist/bundle.tar.gz ./
COPY backstage/app-config*.yaml ./

RUN tar xzf bundle.tar.gz && rm bundle.tar.gz
RUN chown -R node:node /backstage

USER node

CMD ["node", "packages/backend/dist/index.cjs.js", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
