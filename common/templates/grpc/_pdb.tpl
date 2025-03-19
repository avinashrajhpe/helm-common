{{ define "common.service.pdb" }}
{{- if .Values.grpc.enabled -}}
{{- if .Values.grpc.pdb.enabled -}}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "dsccservice.grpc.pdbName" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccservice.common.Labels" . | nindent 4 }}
    app.kubernetes.io/name: {{ include "dsccservice.grpc.pdbName" . }}
spec:
  maxUnavailable: {{ .Values.grpc.pdb.maxUnavailable }}
  selector:
    matchLabels:
      {{- include "dsccservice.grpc.SelectorLabels" . | nindent 6 }}
{{- end -}}
{{- end -}}
{{- end }}
