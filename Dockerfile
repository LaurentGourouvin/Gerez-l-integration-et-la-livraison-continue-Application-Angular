# Using alpine as it's a lightweight image
FROM node:20-alpine3.21 AS build

WORKDIR /app

COPY package*.json ./

# Cache .npm directory to speed up builds
RUN --mount=type=cache,target=/root/.npm npm ci

COPY . .
RUN npm run build

FROM nginx:1.27-alpine as runner

# Copy the build output from the first stage to /app
COPY --from=build /app/dist/*/browser /app

# Copy nginx config into the container
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Use nginx user to avoid running as root
USER nginx

EXPOSE 80

# Force nginx to use my config and run in the foreground
ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]
