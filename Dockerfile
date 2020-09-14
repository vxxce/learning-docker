FROM        node:latest
LABEL       author="Zachary Olpin"
ENV         NODE_ENV=development
ENV         PORT=5000
COPY        .  /var/www
WORKDIR     /var/www
RUN         npm install
EXPOSE      $PORT
ENTRYPOINT  ["npm", "start"]
