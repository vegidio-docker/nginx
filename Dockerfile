FROM nginx
MAINTAINER Vinicius Egidio <me@vinicius.io>

# Installing Let's Encrypt
RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list
RUN apt-get update
RUN apt-get install -y certbot -t jessie-backports

# Adding the renew script to the crontab
ADD renew.sh /etc/cron.daily/renew-certs
RUN chmod +x /etc/cron.daily/renew-certs

CMD ["nginx", "-g", "daemon off;"]
