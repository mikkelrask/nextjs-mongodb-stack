FROM node:current-alpine3.21

RUN echo "Installing tools 🛠️"
RUN apk add --no-cache git mongodb-tools

RUN echo "Getting pnpm 📦"
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.shrc" SHELL="$(which sh)" sh -
ENV PATH="/root/.local/share/pnpm:$PATH"

RUN echo "Cloning repo ⏬"
ARG REPO_URL
RUN git clone ${REPO_URL} app

WORKDIR /app
COPY .env .env
COPY entrypoint.sh /entrypoint.sh

RUN echo "Making scripts executable 🚀"
RUN chmod +x /entrypoint.sh

RUN echo "Installing node packages 📦"
RUN pnpm install

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
