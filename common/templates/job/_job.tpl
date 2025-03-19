{{ define "common.job.job"}}
{{- if .Values.authEnabler.enabled -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "dsccjob.Name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{ include "dsccjob.Labels" . | nindent 4 }}
spec:
  template:
    metadata:
      labels:
      {{ include "dsccjob.Labels" . | nindent 8 }}
      {{- if .Values.authEnabler.pod.annotations }}
      annotations:
        {{- toYaml .Values.authEnabler.pod.annotations | nindent 8 }}
      {{- end }}
    spec:
      {{- if .Values.serviceAccount.use }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      automountServiceAccountToken: false
      {{- if .Values.authEnabler.pod.securityContext }}
      securityContext:
        {{- toYaml .Values.authEnabler.pod.securityContext | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Values.authEnabler.container.image.name }}
          {{- if .Values.authEnabler.container.securityContext }}
          securityContext:
            {{- toYaml .Values.authEnabler.container.securityContext | nindent 12 }}
          {{- end }}
          image: "dsccjob:development"
          imagePullPolicy: Never
          {{- if .Values.authEnabler.container.resources }}
          resources:
            {{- toYaml .Values.authEnabler.container.resources | nindent 12 }}
          {{- end }}
          env:
          {{- include "dsccjob.envVars" .Values.authEnabler.env | indent 10 }}
          volumeMounts:
            {{- if .Values.saVolumeMounts }}
              {{- toYaml .Values.saVolumeMounts | nindent 12 }}
            {{- end }}
            - name: service-discovery
              mountPath: /etc/ops-config
            - name: app-config
              mountPath: /etc/app-config
      volumes:
        {{- if .Values.saVolume }}
          {{- toYaml .Values.saVolume | nindent 8 }}
        {{- end }}
        - name: service-discovery
          configMap:
            name: sc-ops-service-discovery
            items:
              - key: postgresEndpoint
                path: database/hostname
              - key: api_url
                path: keycloak/api_hostname
        - name: app-config
          configMap:
            name: {{ include "dsccjob.Name" . }}
      restartPolicy: Never
  backoffLimit: {{ .Values.authEnabler.backoffLimit }}
  ttlSecondsAfterFinished: {{ .Values.authEnabler.ttlSecondsAfterFinished }}
{{- end -}}
{{- end }}