# vegidio/nginx

[![Actions](https://github.com/vegidio-docker/nginx/workflows/build/badge.svg)](https://github.com/vegidio-docker/nginx/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/vegidio/nginx.svg)](https://hub.docker.com/r/vegidio/nginx)
[![Apache 2.0](https://img.shields.io/badge/license-Apache_License_2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

A Docker image for Nginx with [Certbot](https://certbot.eff.org) installed and the auto TLS certificate renewal enabled by default.

This image inherits directly from the [official Nginx image](https://hub.docker.com/_/nginx) in the Docker Store.

## 🤖 Usage

### Pre-built image

Run the container using pre-built image **vegidio/nginx**:

```
$ docker run -d \
    --mount type=bind,source=/etc/letsencrypt/certs,target=/etc/letsencrypt \
    --mount type=bind,source=/etc/letsencrypt/libs,target=/var/lib/letsencrypt \
    --mount type=bind,source=/etc/nginx/sites,target=/etc/nginx/conf.d \
    -p 80:80 -p 443:443 \
    --name nginx vegidio/nginx
```

### Build the image

In the project root folder, type:

```
$ docker build -t vegidio/nginx .
```

## 🔐 Enabling HTTPS

In order to enable secure connections in your domain, Certbot needs to validate the domain and make sure that you actually own it. There are many ways to do that, but the easiest way is using the [TXT record challenge](https://certbot.eff.org/docs/using.html). The instructions here are based on this validation strategy.

### Creating a certificate

There are two methods validate the DNS using the TXT record challenge:

The first one (and easiest) is using one the DNS plugins, based on the cloud service that you use ([Amazon Route 53](https://certbot-dns-route53.readthedocs.io), [Cloudflare](https://certbot-dns-cloudflare.readthedocs.io), [CloudXNS](https://certbot-dns-cloudxns.readthedocs.io), [Digital Ocean](https://certbot-dns-digitalocean.readthedocs.io), [DNSimple](https://certbot-dns-dnsimple.readthedocs.io), [DNS Made Easy](https://certbot-dns-dnsmadeeasy.readthedocs.io), [Dynamic DNS](https://certbot-dns-rfc2136.readthedocs.io), [Google](https://certbot-dns-google.readthedocs.io), [Linode](https://certbot-dns-linode.readthedocs.io), [LuaDNS](https://certbot-dns-luadns.readthedocs.io), [NS1](https://certbot-dns-nsone.readthedocs.io), [OVH](https://certbot-dns-ovh.readthedocs.io)). The second method is updating your domain's TXT record manually and following the instructions given by Certbot.

Regardless of the method chosen, Plugin or Manual based, before you run any of the commands below in your host server terminal (the server where Docker is installed), don't forget the replace the values for `--email` with your e-mail address and `--domain` with the domain that you're trying to create the certificate.

#### Plugins

Examples of certificate creation using different could services:

<details><summary>Digital Ocean</summary>

```
$ docker run \
    -v /etc/letsencrypt/certs:/etc/letsencrypt \
    -v /etc/letsencrypt/libs:/var/lib/letsencrypt \
    -it --rm vegidio/nginx \
    certbot certonly \
    --dns-digitalocean \
    --dns-digitalocean-credentials ~/digitalocean-creds.ini \
    --email email@example.com \
    --domain "domain.tld" --domain "*.domain.tld"
```
</details>

#### Manual

1. Start with:

```
$ docker run \
    -v /etc/letsencrypt/certs:/etc/letsencrypt \
    -v /etc/letsencrypt/libs:/var/lib/letsencrypt \
    -it --rm vegidio/nginx \
    certbot certonly --agree-tos \
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

### Certificate renewal

This image is configured to automatically renew all certificates created using one of the [Plugin](#plugins) methods, but if you want to force the certificate renew, you can login on the container image and run the command:

```
$ certbot renew -q --force-renewal --post-hook "nginx -s reload"
```

**Attention:** Certificates that were created using the [Manual](#manual) method cannot be automatically renewed. Before the certificate is about to expire, you need create a brand new certificate. 

### Checking your certificate status

You can check the status of your certificates accessing the website [crt.sh](https://crt.sh).

## 🧩 Creating server blocks

The third volume parameter (`-v`) that you define when you [run](#pre-built-image) the Nginx container refers to folder where your server blocks are stored in the host machine. Any configuration file put there will be automatically loaded by Nginx when it starts.

1. Replace the folder `/etc/nginx/sites` for the correct path location where your server block files are stored in the host machine. The second path `/etc/nginx/conf.d` in the container **must not** be changed.

2. Create a new server block for your site (you can use one of the examples found in the [/serverblock](https://github.com/vegidio-docker/nginx/tree/master/serverblock) folder) in the same directory that you defined above.

3. You can now start the server.

## 📝 License

**vegidio/nginx** is released under the Apache License. See [LICENSE](LICENSE.txt) for details.

## 👨🏾‍💻 Author

Vinicius Egidio ([vinicius.io](http://vinicius.io))