{{ define "common.service.autoscaler" }}
{{- if .Values.grpc.enabled -}}
{{- if .Values.grpc.autoscaling.enabled -}}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "dsccservice.grpc.HpaName" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccservice.common.Labels" . | nindent 4 }}
    app.kubernetes.io/name: {{ include "dsccservice.grpc.HpaName" . }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "dsccservice.grpc.Name" . }}
  minReplicas: {{ .Values.grpc.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.grpc.autoscaling.maxReplicas }}
  metrics:
  {{- if .Values.grpc.autoscaling.targetCPUAverageValue }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.grpc.autoscaling.targetCPUAverageValue }}
  {{- end }}
  {{- if .Values.grpc.autoscaling.targetMemoryAverageValue}}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ .Values.grpc.autoscaling.targetMemoryAverageValue }}
  {{- end }}
{{- end -}}
{{- end -}}
{{- end }}
