FROM nginx:alpine

# Copy web application files
COPY sudoku.html /usr/share/nginx/html/index.html
COPY README.md /usr/share/nginx/html/
COPY sudoku-architecture.drawio /usr/share/nginx/html/

# Create nginx configuration for SPA
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
