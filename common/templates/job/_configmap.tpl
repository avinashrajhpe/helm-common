{{ define "common.job.configmap" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "dsccjob.Name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccjob.Labels" . | nindent 4 }}
  annotations:
    strategy.spinnaker.io/versioned: "false"
data:
  database.name: {{ .Values.config.database.name }}
  database.sslmode: {{ .Values.config.database.sslmode }}
  logging.level: {{ .Values.config.logging.level }}
  keycloak.url: {{ .Values.config.keycloak.url }}
  keycloak.api_relative_path: {{ .Values.config.keycloak.api_relative_path }}
  retry.max_retries: "{{ .Values.config.retry.max_retries }}"
  retry.base_delay: "{{ .Values.config.retry.base_delay }}"
  retry.backoff_factor: "{{ .Values.config.retry.backoff_factor }}"
{{- end }}