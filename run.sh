docker run --name nginx -v $PWD/www:/usr/share/nginx/html:ro -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -p 90:80 -d nginx-arm

#docker run --name nginx -v $PWD/www:/usr/share/nginx/html:ro -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro -p 90:80 -d compulsivecoder/nginx-arm

