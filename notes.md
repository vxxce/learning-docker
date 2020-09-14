What is it good for?

- Consistency between machines
- Smoother publishing/production
- Speeding up setup
- Sharing containers socially. Can grab one as like a template.
- Developer onboarding! Speed, safety, etc.
- Eliminating app conflicts and worry less about versioning. Can make version upgrades and run in own container.
- Ship the product faster

# Notes

 ## Features

- Lightweight, open
- Runs natively on Linux
- VM required for Mac or Windows

## Image vs Container:

- Image builds a container. It's the blueprint to get a container running.
- Image is a read-only template. It's made of layered filesystem. Files for OS, Framework, etc.
- Container is created from image and is the thing that can be run, started, stopped, moved, deleted. You make instances of a container (multiple).

## Docker vs VM.

- Container sits on top of host OS, but a VM sits on top of full copy of an OS (called a guest OS) which sits on top of the host OS.

## Tools required:

- For legacy, _Docker Toolbox_ (deprecated). Uses VM called VirtualBox.
- For modern (Windows 10 pro or higher, or Mac) _Docker Desktop_.
  - Provides image and container tools. Uses Hyper-V (windows) or Hyperkit (Mac)
  - Docker Desktop comes with:
    - Docker Client
    - Docker Compose
    - Allows Docker Kitematic to work (but installed separately).

### Docker Client:

- Interact with Docker Engine. Build and manage images. Run containers.- Commands:
  - `docker pull [image name]` (pulls an image from docker hub)
  - `docker run [image name]` (runs a container off an image)
  - `docker images` (lists images)
  - `docker ps` (lists running docker processes)
  - `docker ps -a` (lists *all* docker processes)
  - `docker rm [container name]` (removes a container)
  - `docker rmi [image name]` (removes an image)
  - `docker run -p [host port]:[container port]` (removes an image)
  - `docker stop [container id | container alias]` (stops a running container)
   
## Layered File System:

- Read only files that comprise image
- Read/write container layer on top of image layers
- Containers can share image layers

## Containers and Volumes:

- If you delete a container, you lose all files in container layer.
- A volume is a special directory in a container. Called "data volume"
- Updating an image does not affect data volume
- Data volume persists even if container is deleted (good for e.g log files)

## Getting source code into container:

- Can write it into image layer directly or container layer.
- Can create a data volume that will read or write to a particular location on the host machine with:
  - `docker run -p [host port]:[container port] -v [desired host location]:[container volume] [container name]`
  - Example:

  ```console
  $ docker run -p 8080:3000 -v $(pwd):/var/www node
                             ^    ^      ^
                             |    |      |
                             creates new volume.
                                  |      |
                                  specifies the present working directory as host location
                                         |
                                         container volume
  ``` 
  
- Can edit source at the host location and it will be written to data volume. This lets source code persist if container is deleted.

### Example with basic express server:

```console
$ mkdir example
$ cd example
$ touch server.js
$ npm init -y
$ npm i express
```

*Edit server.js:*

```node
const express = require('express');
const server = express();

server.get('/', (req, res) => {
  res.send('nice');
})

server.listen('5000', () => console.log('running on 5000'))
```

*Pull latest node image:*

`$ docker pull node`

*Run node container linking in source code into container:*

```$ docker run -p 5000:5000 -v $(pwd):/var/www -w "/var/www" node server.js
                                                      ^
                                                      |
                                                      Specify working directory in container
```

  - Now container and image can be deleted without deleting source code on local machine

    ```console
    $ docker ps
    $ docker rm [node container id]
    $ docker rmi node
    $ ls
      node_modules/  server.js  package-lock.json  package.json
    ```
    
## Building custom image:

- Can get source code into the *image* itself too, by building a custom image
- To build an image, you use a Dockerfile
- Dockerfile is just a text file with build instructions
- Instructions create intermediate images that can be cached to speed up future builds
- Key Dockerfile instructions:
  - `FROM` (create an image from another image)
  - `LABEL` (specifiy author)
  - `RUN` (run a command)
  - `COPY` (copy source code into container)
  - `ENTRYPOINT`
  - `WORKDIR`
  - `EXPOSE`
  - `ENV`
  - `VOLUME`

### Example custom Dockerfile for Node app:

  ```dockerfile
  FROM        node:latest
  LABEL       author="Zach"
  ENV         NODE_ENV=production
  ENV         PORT=5000
  COPY        .  /var/www
  WORKDIR     /var/www
  RUN         npm install
  EXPOSE      $PORT
  ENTRYPOINT  ["npm", "start"]
  ```

- Dockerfiles must then be *built* to create image with:

`$ docker build  --tag  <Docker ID>/node  .`
