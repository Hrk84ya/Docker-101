# Docker Basics

## Introduction to Docker
Docker is an open-source platform designed to automate the deployment, scaling, and management of applications. Docker packages applications into standardized units called containers that include everything needed to run the software, including libraries, dependencies, and the application code itself.

By using Docker, developers can ensure their applications run consistently across different environments, from development to production, without worrying about system differences.

## Containers
A Docker container is a lightweight, standalone, executable package that includes everything needed to run a piece of software: code, runtime, libraries, and dependencies. Containers are isolated from one another and the host system, which makes them portable and secure. It is running instance of an image. Also, it's mutable.

## Key Features of Containers:
    - Isolation: Each container runs in its own environment, ensuring that it won’t interfere with others.
    - Portability: Containers can run on any system that supports Docker (Linux, Windows, macOS).
    - Efficiency: Unlike virtual machines (VMs), containers share the host system’s kernel, making them more efficient and faster to start.

## Image
A Docker image typically contains everything that is required to run the application. They can be thought of as a blueprint for a container. It is immutable i.e. in order to do any changes you'll have to create new image.

### Image contains:
    - A cut-down OS
    - A runtime environment
    - Application files
    - Third party libraries
    - Environment Variables










