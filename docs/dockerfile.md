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
