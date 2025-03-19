{{ define "common.service.grpc.service" }}
# GRPC service
apiVersion: v1
kind: Service
metadata:
  name: grpc
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccservice.common.Labels" . | nindent 4 }}
    app.kubernetes.io/name: grpc
spec:
  type: {{ .Values.service.ssobroker.type }}
  ports:
    # Explicitly set protocol for istio.
    # name: <protocol>[-<suffix>]
    # appProtocol: <protocol>
    - name: grpc
      port: {{ .Values.service.ssobroker.grpcPort }}
      targetPort: {{ .Values.service.ssobroker.grpcPort }}
      appProtocol: grpc
      protocol: TCP
  selector:
    {{- include "dsccservice.grpc.SelectorLabels" . | nindent 4 }}
{{- end }}