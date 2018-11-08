FROM nginx:alpine
MAINTAINER Vinicius Egidio <me@vinicius.io>

# Installing Let's Encrypt
RUN apk update
RUN apk add certbot

# Adding the renew script to the crontab
ADD renew.sh /etc/periodic/daily/certbot-renew
RUN chmod a+x /etc/periodic/daily/certbot-renew

# Configuring the entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh
