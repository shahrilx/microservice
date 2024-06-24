# Use official node image from docker
FROM public.ecr.aws/docker/library/node:18.20-bookworm-slim
# Create application directory
RUN mkdir -p /usr/src/app

# Change this as work directory
WORKDIR /usr/src/app

# Copy package.json to work directory
COPY package*.json ./

# Run npm install to install packages
RUN npm install

# Copy the application
COPY . /usr/src/app

# Expose port 4000
EXPOSE 4000

# Run the script to start server
CMD [ "npm", "run", "start" ]
