{{ define "common.dbmigrate.job" }}
{{- if .Values.dbMigrate.enabled -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "dsccservice.dbMigrate.Name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{ include "dsccservice.dbMigrate.Labels" . | nindent 4 }}
spec:
  template:
    metadata:
      labels:
      {{ include "dsccservice.dbMigrate.Labels" . | nindent 8 }}
      {{- if .Values.dbMigrate.pod.annotations }}
      annotations:
        {{- toYaml .Values.dbMigrate.pod.annotations | nindent 8 }}
      {{- end }}
    spec:
      {{- if .Values.serviceAccount.use }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      automountServiceAccountToken: {{ .Values.common.pod.automountServiceAccountToken }}
      {{- if .Values.dbMigrate.pod.securityContext }}
      securityContext:
        {{- toYaml .Values.dbMigrate.pod.securityContext | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Values.dbMigrate.container.image.name }}
          {{- if .Values.dbMigrate.container.securityContext }}
          securityContext:
            {{- toYaml .Values.dbMigrate.container.securityContext | nindent 12 }}
          {{- end }}
          image: "dsccjob:development"
          imagePullPolicy: Never
          {{- if .Values.dbMigrate.container.resources }}
          resources:
            {{- toYaml .Values.dbMigrate.container.resources | nindent 12 }}
          {{- end }}
          env:
          {{- include "dsccservice.envVars" .Values.common.env.dbMigrate | indent 10 }}
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
        - name: app-config
          configMap:
            name: {{ include "dsccservice.dbMigrate.Name" . }}
      restartPolicy: Never
  backoffLimit: {{ .Values.dbMigrate.backoffLimit }}
{{- end -}}
{{- end }}