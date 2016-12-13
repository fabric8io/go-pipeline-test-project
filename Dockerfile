FROM scratch

ENTRYPOINT ["/go-pipeline-test-project"]

COPY ./out/go-pipeline-test-project-linux-amd64 /go-pipeline-test-project
