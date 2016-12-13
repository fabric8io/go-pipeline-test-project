FROM scratch

ENTRYPOINT ["/go-pipeline-test-project"]

COPY ./build/go-pipeline-test-project-linux-amd64 /go-pipeline-test-project
