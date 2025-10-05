FROM nginx:latest

# Copy website files into NGINX default directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
