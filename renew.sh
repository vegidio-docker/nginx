#!/bin/bash

certbot renew --renew-hook "nginx -s reload"
