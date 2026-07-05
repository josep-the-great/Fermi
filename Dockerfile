FROM node:18-bullseye AS builder

WORKDIR /devel
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential git
COPY . .
RUN npm ci --legacy-peer-deps && npm run build

FROM node:20-alpine

EXPOSE 8080
WORKDIR /exec
RUN apk add --update nodejs npm
COPY --from=builder /devel/ . 
RUN adduser -D jankclient

USER jankclient

CMD ["npm", "start"]
