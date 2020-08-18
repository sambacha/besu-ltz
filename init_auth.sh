#!/bin/sh
openssl genrsa -out privateKey.pem 2048
openssl rsa -pubout -in privateKey.pem -pubout -out publicKey.pem