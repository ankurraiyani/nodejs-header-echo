#
#  node.js header echo service.
#
FROM node:slim

RUN mkdir -p /srv/header-test /var/www/ && ln -s /srv/header-test /var/www
COPY server.js /srv/header-test/ 

EXPOSE 8080
CMD ["node", "/srv/header-test/server.js"]
