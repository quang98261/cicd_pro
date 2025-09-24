# Sử dụng Node để build
FROM node:18-alpine AS build

WORKDIR /app

# copy package trước để cache layer
COPY package*.json ./
RUN npm install

# copy toàn bộ source
COPY . .

# build React app
RUN npm run build

# Dùng Nginx để serve file tĩnh
FROM nginx:alpine

# copy build từ stage trước sang thư mục serve của nginx
COPY --from=build /app/build /usr/share/nginx/html

# copy file config nginx (nếu cần, thường để fix React Router)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
