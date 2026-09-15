FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm clean-install
RUN npm run build

FROM nginx:alpine
#COPY index.html /usr/share/nginx/html/
COPY --from=build /app/dist /usr/share/nginx/html
#EXPOSE 80
#CMD ["nginx","-g","daemon off;"]