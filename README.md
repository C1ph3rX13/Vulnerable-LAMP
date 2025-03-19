# Vulnerable LAMP

🐳 A fast-deploy Vulnerable container for security research with persistent data storage.

## Key Features

🐳 **Self-Contained Data Storage**

- MySQL data is stored directly within the container

🐳 **Quick-Setup for Research**

- Preconfigured environment optimized for vulnerability analysis and testing

**Usage:**

```bash
docker build -f <Dockerfile Name> -t <Image Name>:tag .
docker run -d -p port:port <Image Name>:tag
```

## Supported System

- Ubuntu 20.04
- Ubuntu 22.04
- Ubuntu 24.04

## Supported Software

- Apache-2.4 
- MySQL-5.x, MySQL-8.x
- PHP-5.6

## MySQL

### MySQL8.x

Image:Ubuntu 22.04

MySQL Version:8.4.3

### MySQL5.x

Image:Ubuntu 22.04

MySQL Version:5.7.34

## PHP WebServer

Image:Ubuntu 22.04

PHP Version:5.6

MySQL  Version:5.7.34

Apache Version:2.4

