FROM node:22-alpine

WORKDIR /app

COPY package.json ./
COPY server.js ./
COPY public/ ./public/
COPY api/ ./api/

ENV HOST=0.0.0.0
ENV PORT=5173

EXPOSE 5173

CMD ["node", "server.js"]
