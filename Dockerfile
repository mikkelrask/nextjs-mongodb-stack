FROM node:current-alpine3.21

RUN echo "Installing tools 🛠️"
RUN apk add --no-cache git mongodb-tools

RUN echo "Getting pnpm 📦"
RUN npm install -g pnpm
RUN which pnpm

WORKDIR /app
COPY .env .env
COPY *.sh /
COPY mongo-dump /mongo-dump

RUN echo "Making scripts executable 🚀"
RUN chmod +x /clone-repo.sh
RUN chmod +x /entrypoint.sh

RUN echo "Cloning repo ⏬"
ARG REPO_URL
RUN ./clone-repo.sh


RUN echo "Installing node packages 📦"
RUN pnpm install

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
