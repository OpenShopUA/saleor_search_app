FROM node:20-alpine AS builder
WORKDIR /app
# Копіюємо файли для встановлення залежностей
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile
# Копіюємо всі файли проекту
COPY . .
# Будуємо проект (генерація схеми, компіляція, і т.д.)
RUN pnpm run build

FROM node:20-alpine AS runner
WORKDIR /app
# Копіюємо збудований проект із попереднього етапу
COPY --from=builder /app . 
# Налаштовуємо production середовище
ENV NODE_ENV=production
EXPOSE 3000
CMD ["pnpm", "start"]
