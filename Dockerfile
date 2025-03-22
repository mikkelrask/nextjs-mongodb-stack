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

COPY scripts/ scripts/ 

RUN echo "Making /app/scripts/restore-dump.sh executable 🚀"
RUN chmod +x /app/scripts/restore-dump.sh

RUN echo "Installing node packages 📦"
RUN pnpm install

RUN echo "Building site 👷🏼"
RUN pnpm build

EXPOSE 3000

RUN echo "Hosting site on 0.0.0.0:3000 ☁️"
CMD ["pnpm", "start"]
