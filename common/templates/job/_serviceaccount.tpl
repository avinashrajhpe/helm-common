{{ define "common.job.serviceaccount" }}
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Values.serviceAccount.name }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccjob.common.Labels" . | nindent 4 }}
    app.kubernetes.io/name: {{ .Values.serviceAccount.name }}
  {{- if .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml .Values.serviceAccount.annotations | nindent 4 }}
  {{- end }}
automountServiceAccountToken: {{ .Values.common.pod.automountServiceAccountToken }}
{{- end -}}
{{- end }}
