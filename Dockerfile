# Build stage
FROM node:alpine AS builder
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies (including devDependencies)
RUN npm install 

# Copy application files
COPY . .

# Build the Next.js app
RUN npm run build


#--------------------------PROD---------------------------------#


# Production stage
FROM node:alpine
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public

# Start the app
CMD ["npm", "start"]
