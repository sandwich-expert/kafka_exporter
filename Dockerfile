FROM golang
WORKDIR /work
RUN pwd
ADD . .
COPY /vendor /go/src/
RUN go build -o /bin/kafka_exporter .
WORKDIR /
RUN rm -r /work
EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]
