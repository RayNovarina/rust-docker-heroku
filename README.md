# per: https://github.com/dongri/hello-rust

-------------------------------------

1) scrub docker for baseline init:
```
  $ docker rm -f $(docker ps -aq)

  $ docker rmi -f $(docker images -q)
```

2) # Docker for mac
```
  $ git clone git@github.com:dongri/hello-rust.git
  $ cd hello-rust

  $ docker-compose up
```
    Step 1/11 : FROM ubuntu:latest
    latest: Pulling from library/ubuntu
    Status: Downloaded newer image for ubuntu:latest
      ---> 0ef2e08ed3fa
    Step 2/11 : MAINTAINER Dongri Jin <dongrify@gmail.com>
          .....
    Step 3/11 : RUN apt-get -y update
      ---> Running in b9e18b36dccf
    Get:1 http://archive.ubuntu.com/ubuntu xenial InRelease [247 kB]
          ......
    done.
    Step 5/11 : RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh
      ---> Running in a90b1f007597
    rustup: gpg available. signatures will be verified
    rustup: downloading manifest for 'stable'
    rustup: downloading toolchain for 'stable'
    ######################################################################## 100.0%
    gpg: assuming signed data in '/root/.rustup.sh/dl/81ee60da92043cc2855b/rust-1.16.0-x86_64-unknown-linux-gnu.tar.gz'
    gpg: Signature made Sat Mar 11 09:37:05 2017 UTC using RSA key ID 7B3B09DC
    gpg: Good signature from "Rust Language (Tag and Release Signing Key) <rust-key@rust-lang.org>"
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: 108F 6620 5EAE B0AA A8DD  5E1C 85AB 96E6 FA1B E5FE
    Subkey fingerprint: C134 66B7 E169 A085 1886  3216 5CB4 A934 7B3B 09DC
    rustup: installing toolchain for 'stable'
    rustup: extracting installer
    install: creating uninstall script at /usr/local/lib/rustlib/uninstall.sh
    install: installing component 'rustc'
         ........       
    install: installing component 'cargo'

         Rust is ready to roll.

      ---> 235a8321b6ce
    Removing intermediate container a90b1f007597
    Step 6/11 : RUN mkdir -p /app
      ---> Running in 0f1389754f64
      ---> e9d1eca08089
    Removing intermediate container 0f1389754f64
    Step 7/11 : WORKDIR /app
      ---> 4405b88048d2
    Removing intermediate container 41e91e291eb6
    Step 8/11 : COPY . /app
      ---> 57258ae0f851
    Removing intermediate container c912de976ecb
    Step 9/11 : RUN cargo build --release
      ---> Running in ad294dd4d0c6
    Updating registry `https://github.com/rust-lang/crates.io-index`
    Updating git repository `https://github.com/iron/router.git`
    Downloading iron v0.4.0
                  .....
    Compiling hello-rust v1.0.0 (file:///app)
    Finished release [optimized] target(s) in 47.44 secs
      ---> 0310a0367871
    Removing intermediate container ad294dd4d0c6
    Step 10/11 : EXPOSE 8080
      ---> Running in 280d570119f8
      ---> 0d739592b98f
    Removing intermediate container 280d570119f8
    Step 11/11 : CMD /app/target/release/hello
      ---> Running in 1c5d24aa5a16
      ---> 3cb851cbb089
    Removing intermediate container 1c5d24aa5a16
    Successfully built 3cb851cbb089
    WARNING: Image for service hello-rust was built because it did not already exist. To rebuild this image you must use 'docker-compose build' or 'docker-compose up --build'.

    Creating hello-rust

    Attaching to hello-rust

      hello-rust    | /bin/sh: 1: /app/target/release/hello: not found

      hello-rust exited with code 127

---------------------------------
```
  $ docker images
    REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
    hellorust_hello-rust   latest              3cb851cbb089        13 minutes ago      747 MB
    ubuntu                 latest              0ef2e08ed3fa        3 weeks ago         130 MB
```
----------------------------------
debug:
  $ docker run -it -p 8080:8080 hellorust_hello-rust bash

    root@66f2cf0296c9:/app# ls target/release
      build  deps  examples  hello  hello.d  incremental  native

    root@66f2cf0296c9:/app# /app/target/release/hello

    open http://localhost:8080 results in "Hello Rust!" msg.

  $ docker run -it -p 8080:8080 hellorust_hello-rust /app/target/release/hello

    results in container running in foreground.

    $ docker ps
      CONTAINER ID        IMAGE                  COMMAND                    PORT                     NAMES
      dadb48a27174        hellorust_hello-rust   "/app/target/relea..."     0.0.0.0:8080->8080/tcp   happy_jennings

    open http://localhost:8080 results in "Hello Rust!" msg.

----------------------------
3) # Heroku

```
$ heroku plugins:install heroku-container-tools

  Installing plugin heroku-container-tools... done

$ heroku create rust-94037
  Creating ⬢ rust-94037... done
  https://rust-94037.herokuapp.com/ | https://git.heroku.com/rust-94037.git

$ heroku container:login
  Login Succeeded

$ heroku container:push web
  Sending build context to Docker daemon 99.84 kB
  Step 1/11 : FROM ubuntu:latest
    ---> 0ef2e08ed3fa
        ...........
  Step 9/11 : RUN cargo build --release
    ---> Running in 1c2029551bc1
  Updating git repository `https://github.com/iron/router.git`
        .......
  Step 10/11 : EXPOSE 8080
    ---> Running in a6895b48181d
    ---> 379230e492cb
  Removing intermediate container a6895b48181d
  Step 11/11 : CMD /app/target/release/hello
    ---> Running in 917aa9bbf84e
    ---> a712a44fe5c2
  Removing intermediate container 917aa9bbf84e
  Successfully built a712a44fe5c2
  The push refers to a repository [registry.heroku.com/rust-94037/web]
  cc1f44ce96f2: Preparing
      ............
  latest: digest: sha256:3c2d4e1c62b5886455e9b79e01365f6665a5b1cba9f1a0a101c376fbaea6907f size: 2621
```

open https://rust-94037.herokuapp.com

  Results in app error, check logs.

  Logs show:

  2017-03- app[api]: Release v3 created by user xx@gmail.com
  2017-03- heroku[router]: at=error code=H14 desc="No web processes running" method=GET path="/" host=rust-94037.herokuapp.com request_id=8da4b61d-22cb-4c00-be23-e85e35be297c fwd="76.126.67.146" dyno= connect= service= status=503 bytes= protocol=https
  2017-03- heroku[router]: at=error code=H14 desc="No web processes running" method=GET path="/favicon.ico" host=rust-94037.herokuapp.com

  Indicates no dyno/container running because no Procfile.

  Add dyno via:
    $ heroku ps:scale web=1

  open https://rust-94037.herokuapp.com results in "Hello Rust!" msg.
