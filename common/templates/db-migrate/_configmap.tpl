{{ define "common.dbmigrate.configmap" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "dsccservice.dbMigrate.Name" . }}
  namespace: {{ .Release.Namespace }}
  annotations:
    strategy.spinnaker.io/versioned: "false"
  labels:
    {{ include "dsccservice.dbMigrate.Labels" . | nindent 4 }}
data:
  database.name: {{ .Values.common.config.database.name }}
  database.sslmode: {{ .Values.common.config.database.sslmode }}
  logging.level: {{ .Values.common.config.logging.level }}
{{- end }}
