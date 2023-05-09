FROM gcr.io/go-containerregistry/crane:v0.10.0 as crane
FROM gcr.io/kaniko-project/executor:v1.9.2-debug

COPY --from=crane /ko-app/crane /usr/local/bin/