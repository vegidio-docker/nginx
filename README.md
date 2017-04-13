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
    -p 80:80 -p 443:443 \
    --name nginx vegidio/nginx
```

### Build the image

In the project root folder, type:

```
$ docker build -t my-nginx-image .
```

## Enabling HTTPS

In order to enable secure connections in your domain, Certbot needs to validate the domain and make sure that you actually own it. There are many ways to do that, but the easiest way is using the [Webroot](https://certbot.eff.org/docs/using.html#webroot) plugin. The instructions here are based on this validation strategy.

### Creating a certificate

1. Create a server block following the same pattern of [sb.example.conf](https://github.com/vegidio/docker-nginx/blob/master/sb.example.conf). Remember to replace the **domain.tld** in the file for your real domain.

2. Start the Nginx container with the server block above and login in the container using `docker exec -it container_name bash`.

3. After you are in the container's shell enter the command below, but don't forget the replace the values for `--email` with your e-mail address and `--domain` with the domain that you're trying to create the certificate:

```
certbot certonly --non-interactive --agree-tos \
    --email email@example.com \
    --webroot -w /var/www/domain.tld \
    --domain domain.tld --domain www.domain.tld
```

After you enter the command above - if everything goes well - the certificate will be generated and saved in the folder `/etc/letsencrypt/live/domain.tld`.

### Certificate renewal

This image is configured to automatically renew all certificates, but if you want to force the certificate renew, you can login on the container image and run the command:

`certbot renew -q --force-renewal --post-hook "nginx -s reload"`

## Checking your certificate status

You can check the status of your certificates accessing the website [crt.sh](https://crt.sh/).

## License

**vegidio/nginx** is released under the Apache License. See [LICENSE](LICENSE.txt) for details.

## Author

Vinicius Egidio ([vinicius.io](http://vinicius.io))
