FROM node:16-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY pages ./pages
COPY public ./public
COPY styles ./styles
COPY components ./components

CMD ["npm","run","dev","--","-p","80"]