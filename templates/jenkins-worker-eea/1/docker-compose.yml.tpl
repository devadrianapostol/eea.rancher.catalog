version: "2"
services:
  worker:
    image: eeacms/jenkins-slave-eea:3.6
    labels:
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.affinity:host_label: ${HOST_LABELS}
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
    environment:
      JAVA_OPTS: "${JAVA_OPTS}"
      JENKINS_MASTER: "http://jenkins-master:8080"
      JENKINS_NAME: "${JENKINS_NAME}"
      JENKINS_RETRY: "${JENKINS_RETRY}"
      JENKINS_USER: "${JENKINS_USER}"
      JENKINS_PASS: "${JENKINS_PASS}"
      JENKINS_LABELS: "${JENKINS_LABELS}"
      JENKINS_OPTS: "${JENKINS_OPTS}"
      TZ: "${TZ}"
    external_links:
    - "${JENKINS_MASTER}:jenkins-master"
    depends_on:
    - postgres
    volumes:
    - jenkins-worker:/var/jenkins_home/worker

  postgres:
    image: eeacms/postgres:9.6
    labels:
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.affinity:host_label: ${HOST_LABELS}
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
    environment:
      POSTGRES_DBNAME: "datafs zasync"
      POSTGRES_DBUSER: "zope"
      POSTGRES_DBPASS: "zope"
      TZ: "${TZ}"

{{- if eq .Values.VOLUME_DRIVER "rancher-ebs"}}

volumes:
  jenkins-worker:
    driver: ${VOLUME_DRIVER}
    driver_opts:
      {{.Values.VOLUME_DRIVER_OPTS}}

{{- end}}
