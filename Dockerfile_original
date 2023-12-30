#FROM ubuntu:latest
FROM node:20-alpine3.19
LABEL authors="ds"
ENV TIME_ZONE=America/Halifax \
    APP_PORT=1234 \
    DB_HOST=pg \
    DB_PORT=5432 \
    DB_PASSWORD=secret
COPY . /app
WORKDIR /app
RUN npm install
EXPOSE $APP_PORT
# why not CMD
ENTRYPOINT ["npm", "start"]