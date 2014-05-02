# docker-adminer

[Adminer](http://www.adminer.org/en/) is a full-featured database management
tool for the web. It is a lightweight alternative to setting up phpMyAdmin.
This is a [docker](https://www.docker.io) image that eases setup.

## Build

```bash
$ git clone https://github.com/clue/docker-adminer.git
$ cd docker-adminer
$ sudo docker build -t adminer .
```

### Running

This container does not contain its own database,
but instead allows you to connect to a running instance. 

This makes this container disposable, as it doesn't store any sensitive
information at all.

#### Running Adminer temporarily

```bash
$ sudo docker run -it --rm -p 80:80 adminer
```

#### Running Adminer daemonized

```bash
$ sudo docker run -d -p 80:80 adminer
```

### Accessing your webinterface

The above examples expose the Adminer webinterface on port 80, so that you can browse to:

http://localhost/

