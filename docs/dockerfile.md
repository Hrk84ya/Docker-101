## Guide to Writing Dockerfiles
### Introduction to Dockerfiles
A Dockerfile is a text file that contains a set of instructions to build a Docker image. It defines the base image, environment settings, and commands needed to configure and run your application in a container. Writing a good Dockerfile ensures that your images are efficient, reproducible, and maintainable.

This guide will cover the basic syntax, some best practices, and a few example Dockerfiles for different scenarios.

### Dockerfile Syntax
A Dockerfile consists of a series of instructions, each specifying an action to perform. The most common instructions include:

1. **FROM**<br>
    - Specifies the base image from which your Docker image is built.<br>
    - Syntax: ```FROM node:16-alpine```

2. **WORKDIR**<br>
    - Sets the working directory for any subsequent instructions. If the directory does not exist, it will be created.<br>
    - Syntax: ```WORKDIR /app```
3. **COPY**<br>
    - Copies files from the host system to the container’s filesystem.<be>
    - Syntax: ```COPY . .```
4. **RUN**<br>
    - Executes commands inside the container during the build process.<br>
    - Syntax: ```RUN npm install```
5. **CMD**<br>
    - Specifies the command that will run when a container is started from the image. You can only have one CMD instruction per Dockerfile. If multiple CMD instructions are provided, only the last one is executed.
    - Syntax: ```CMD ["node", "server.js"]```
6. **EXPOSE**<br>
    - Informs Docker that the container will listen on the specified network ports at runtime. This does not publish the port; it’s for documentation purposes.<br>
    - Syntax: ```EXPOSE 3000```
7. **ENV**<br>
    - Sets environment variables in the container.<br>
    - Syntax: ```ENV NODE_ENV=production```
8. **ENTRYPOINT**<br>
    - Similar to CMD, but it configures a container to run as an executable. Unlike CMD, ENTRYPOINT will always be executed, even if additional arguments are passed to docker run.<br>
    - ENTRYPOINT ["npm", "start"]

## Best Practices for Writing Dockerfiles<br>
To create optimized and maintainable Dockerfiles, consider following these best practices:<br>

1. **Use Official Base Images**<br>
  - You can use official images whenever possible, as they are well-maintained and trusted.<br>
  - FROM python:3.9-slim
2. **Use Small Base Images**<br>
  - Choose lightweight base images like alpine to reduce the size of the final image.<br>
  - FROM node:16-alpine
3. **Limit the Number of Layers**<br>
  - Each RUN, COPY, or ADD command creates a new layer. Combine commands to reduce the number of layers.<br>
  - #### Instead of separate RUN commands:
    * RUN apt-get update
    * RUN apt-get install -y curl
  - #### Use this:
    * RUN apt-get update && apt-get install -y curl
4. **Leverage Caching**<br>
  - Place frequently changing instructions like `COPY` and `RUN` commands towards the end of the Dockerfile to maximize the cache efficiency.<br>

5. **Use Multi-Stage Builds**<br>
  - For applications with build steps (like compiling code), use multi-stage builds to reduce image size by only including the necessary artefacts in the final image.<br>
  - #### Multi-stage build example
    * FROM node:16-alpine AS builder
    * WORKDIR /app
    * COPY package*.json ./
    * RUN npm install
    * COPY . .
    * RUN npm run build

  - #### Final stage
    * FROM nginx:alpine
    * COPY --from=builder /app/build /usr/share/nginx/html
6. **Minimize the Number of Layers**<br>
  - Each instruction in a Dockerfile creates a new layer. To keep your images lightweight, minimize unnecessary instructions.<br>
    * RUN apt-get update && apt-get install -y \
    * curl \
    * vim
7. **Add Metadata**<br>
  - Include labels to add metadata to your images.<br>
    * LABEL maintainer="your-email@example.com"
8. **Avoid Hardcoding Values**<br>
  - Where possible, use environment variables to avoid hardcoding values in the Dockerfile.<br>
    * ENV APP_PORT=3000
    * EXPOSE $APP_PORT
