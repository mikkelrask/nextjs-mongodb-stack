FROM node:current-alpine3.21

RUN echo "Installing tools 🛠️ "
RUN apk add --no-cache git mongodb-tools

RUN echo "Getting pnpm 📦"
RUN npm install -g pnpm

COPY .env /.env
COPY clone-repo.sh /clone-repo.sh
COPY entrypoint.sh /entrypoint.sh
COPY mongo-dump /mongo-dump

RUN echo "Making scripts executable 🚀"
RUN chmod +x /clone-repo.sh
RUN chmod +x /entrypoint.sh

RUN echo "Cloning repo ⏬"
ARG REPO_URL
RUN export $(grep -v '^#' .env | xargs 2>/dev/null || true) && \
    REPO_URL=${REPO_URL} /clone-repo.sh

WORKDIR /app
COPY .env .env

RUN echo "Installing node packages 📦"
RUN pnpm install

ARG NEXTJS_PORT
EXPOSE ${NEXTJS_PORT}

ENTRYPOINT ["/entrypoint.sh"]
