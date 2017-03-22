FROM ubuntu:latest

MAINTAINER Dongri Jin <dongrify@gmail.com>

RUN apt-get -y update
RUN apt-get -y install curl file sudo gcc

# install Rust (https://www.rust-lang.org/en-US/downloads.html)
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh

RUN mkdir -p /app

WORKDIR /app

COPY . /app

RUN pwd
RUN ls
RUN ls /app

RUN cargo build --release

RUN ls /app/target/release

EXPOSE 8080

CMD /app/target/release/hello
