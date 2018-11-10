# vegidio/nginx

[![Travis](https://img.shields.io/travis/vegidio/docker-nginx.svg)](https://travis-ci.org/vegidio/docker-nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/vegidio/nginx.svg)](https://store.docker.com/community/images/vegidio/nginx)
[![Apache 2.0](https://img.shields.io/badge/license-Apache_License_2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

A Docker image for Nginx with [Certbot](https://certbot.eff.org) installed and the auto SSL certificate renewal enabled by default.

This image inherits directly from the [official Nginx image](https://store.docker.com/images/nginx) in the Docker Store.

## Usage

### Pre-built image

Run the container using pre-built image **vegidio/nginx**:

```
$ docker run -d \
    -v /etc/letsencrypt/certs:/etc/letsencrypt \
    -v /etc/letsencrypt/libs:/var/lib/letsencrypt \
    -p 80:80 -p 443:443 \
    --name nginx vegidio/nginx
```

### Build the image

In the project root folder, type:

```
$ docker build -t vegidio/nginx .
```

## Enabling HTTPS

In order to enable secure connections in your domain, Certbot needs to validate the domain and make sure that you actually own it. There are many ways to do that, but the easiest way is using the manual [TXT record challenge](https://certbot.eff.org/docs/using.html#manual) plugin. The instructions here are based on this validation strategy.

### Creating a certificate

1. In your host server terminal (the server where Docker is installed), please run the command below to validate your domain, but don't forget the replace the values for `--email` with your e-mail address and `--domain` with the domain that you're trying to create the certificate:

```
$ docker run \
    -v /etc/letsencrypt/certs:/etc/letsencrypt \
    -v /etc/letsencrypt/libs:/var/lib/letsencrypt \
    -it --rm vegidio/nginx \
    certbot certonly --agree-tos \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --manual --preferred-challenges dns \
    --email email@example.com \
    --domain "domain.tld" --domain "*.domain.tld"
```

2. After you answer a few questions regarding your domain, Certbot will generate a hash to update your domain with a **TXT record**. The TXT record is named `_acme-challenge` and the hash looks like this `NZXXXLm6LL8uiiqLlqigFTLvB8KZTaFmXXXX` (this is just an example).

If you don't know how to update the TXT record in your domain, please consult the documentation of your domain registrar (Namecheap, GoDaddy, etc).

3. It can take up to a few minutes until your changes in the TXT record are propagated, but you can track if the changes are propagated already by opening a new terminal window and using the command (replaced `domain.tld` with your real domain):

```
$ dig -t txt _acme-challenge.domain.tld
```

Keep running the command above every few seconds until you see that the TXT record `_acme-challenge` is already available.

4. After the TXT record is updated, you can return to the original terminal where Certbot is running and continue the validation process. If everything goes well then the certificate and all other necessary files will be generated and saved in the folder `/etc/letsencrypt/` in your host server.

5. You can now start the container and use it.

### Certificate renewal

This image is configured to automatically renew all certificates, but if you want to force the certificate renew, you can login on the container image and run the command:

`$ certbot renew -q --force-renewal --post-hook "nginx -s reload"`

## Checking your certificate status

You can check the status of your certificates accessing the website [crt.sh](https://crt.sh/).

## License

**vegidio/nginx** is released under the Apache License. See [LICENSE](LICENSE.txt) for details.

## Author

Vinicius Egidio ([vinicius.io](http://vinicius.io))
