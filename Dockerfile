FROM node:20-alpine AS builder
WORKDIR /app
# Копіюємо package.json, а файл pnpm-lock.yaml виключаємо, якщо його нема
COPY package.json ./
# Якщо у вас є lock-файл, поставте його копіювання, інакше закоментуйте цей рядок
# COPY pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
# Копіюємо решту файлів
COPY . .
RUN pnpm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app . 
ENV NODE_ENV=production
EXPOSE 3000
CMD ["pnpm", "start"]