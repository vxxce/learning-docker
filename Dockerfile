FROM        node:latest
LABEL       author="Zach"
ENV         NODE_ENV=production
ENV         PORT=5000
COPY        .  /var/www
WORKDIR     /var/www
RUN         npm install
EXPOSE      $PORT
ENTRYPOINT  ["npm", "start"]
