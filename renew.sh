#!/bin/sh

certbot renew --renew-hook "nginx -s reload"