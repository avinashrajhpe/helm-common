{{ define "common.service.configmap" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "dsccservice.grpc.Name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccservice.grpc.Labels" . | nindent 4 }}
  annotations:
    strategy.spinnaker.io/versioned: "false"
data:
  database.name: {{ .Values.common.config.database.name }}
  database.sslmode: {{ .Values.common.config.database.sslmode }}
  logging.level: {{ .Values.common.config.logging.level }}
  metrics.path: {{ .Values.common.config.metrics.path }}
  metrics.port: {{ .Values.common.config.metrics.port | quote }}
  grpcserver.port: {{ .Values.common.config.grpc.port | quote }}
  grpcprivateserver.port: {{ .Values.common.config.grpcPrivate.port | quote }}
  restserver.port: {{ .Values.common.config.rest.port | quote }}
  tracing.service: {{ .Values.common.config.tracing.service }}
  tracing.otlptracehttpendpoint: {{ .Values.common.config.tracing.otlptracehttpendpoint }}
  keycloak.url: {{ .Values.common.config.keycloak.url }}
  keycloak.api_relative_path: {{ .Values.common.config.keycloak.api_relative_path }}
  # The `custom_authenticator_enabled` is set as a string value in Helm and ConfigMap
  # instead of a boolean value to ensure compatibility with Kubernetes templating and
  # configuration management. As, helm templates and Kubernetes ConfigMaps treat all values
  # as strings
  keycloak.custom_authenticator_enabled: {{ .Values.common.config.keycloak.custom_authenticator_enabled | quote }}
  {{- if .Values.common.config.authz }}
  authz.endpoint: {{ .Values.common.config.authz.endpoint }}
  authz.secretsImplicitPermissionID: {{ .Values.common.config.authz.secretsImplicitPermissionID}}
  {{- end }}
  {{- if .Values.common.config.secrets }}
  secrets.endpoint: {{ .Values.common.config.secrets.endpoint }}
  {{- end }}
  {{- end }}
