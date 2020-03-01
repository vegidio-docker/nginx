FROM nginx:alpine
LABEL maintainer="Vinicius Egidio <me@vinicius.io>"

# Installing Certbot
RUN apk --upgrade --no-cache add py-pip certbot \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/main \
    -X http://dl-cdn.alpinelinux.org/alpine/edge/community

# Installing Certbot's Plugins
RUN pip install certbot-dns-cloudflare certbot-dns-cloudxns certbot-dns-digitalocean certbot-dns-dnsimple \
    certbot-dns-dnsmadeeasy certbot-dns-google certbot-dns-linode certbot-dns-luadns certbot-dns-nsone \
    certbot-dns-ovh certbot-dns-rfc2136 certbot-dns-route53

# Adding the renew script to the crontab
COPY renew.sh /etc/periodic/daily/certbot-renew
RUN chmod a+x /etc/periodic/daily/certbot-renew

# Configuring the entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh