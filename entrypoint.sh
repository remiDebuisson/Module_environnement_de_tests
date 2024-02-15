#!/bin/bash 
# Démarrer Nginx en arrière-plan 
nginx -g 'daemon off;' &  
# Démarrer le serveur Symfony 
symfony server:start --port=9000 --no-tls
# Garder le conteneur en marche 
tail -f /dev/null
