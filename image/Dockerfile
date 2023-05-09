FROM jenkins/jenkins:2.387.2-lts-jdk17

RUN jenkins-plugin-cli --plugins git:5.0.0
RUN jenkins-plugin-cli --plugins configuration-as-code:1625.v27444588cc3d
RUN jenkins-plugin-cli --plugins javax-mail-api:1.6.2-9
RUN jenkins-plugin-cli --plugins kubernetes:3923.v294a_d4250b_91
RUN jenkins-plugin-cli --plugins sshd:3.275.v9e17c10f2571
RUN jenkins-plugin-cli --plugins workflow-aggregator:596.v8c21c963d92d
RUN jenkins-plugin-cli --plugins pipeline-stage-view:2.32
RUN jenkins-plugin-cli --plugins job-dsl:1.83
RUN jenkins-plugin-cli --plugins pipeline-graph-view:183.v9e27732d970f

USER jenkins