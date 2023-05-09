FROM jenkins/inbound-agent:3107.v665000b_51092-5-alpine-jdk17 as jnlp
FROM maven:3.9.1-eclipse-temurin-17-alpine

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]