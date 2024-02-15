#!/bin/bash 
# Démarrer Nginx en arrière-plan 
nginx -g 'daemon off;' &  symfony server:start --port=9000 --no-tls
# Garder le conteneur en marche 
tail -f /dev/null
