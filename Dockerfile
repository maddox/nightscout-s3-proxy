FROM amazon/aws-cli

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./run .
CMD ["./run"]
ENTRYPOINT []
