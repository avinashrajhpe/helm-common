{{ define "common.service.deployment" }}
{{- if .Values.grpc.enabled -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "dsccservice.grpc.Name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "dsccservice.grpc.Labels" . | nindent 4 }}
  annotations:
    kube-score/ignore: pod-probes
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  {{- if not .Values.grpc.autoscaling.enabled }}
  replicas: {{ .Values.grpc.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "dsccservice.grpc.SelectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "dsccservice.grpc.Labels" . | nindent 8 }}
      {{- if .Values.grpc.pod.annotations }}
      annotations:
        {{- toYaml .Values.grpc.pod.annotations | nindent 8 }}
      {{- end }}
    spec:
      {{- if .Values.serviceAccount.use }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      automountServiceAccountToken: {{ .Values.common.pod.automountServiceAccountToken }}
      {{- if .Values.grpc.pod.securityContext }}
      securityContext:
        {{- toYaml .Values.grpc.pod.securityContext | nindent 8 }}
      {{- end }}
      terminationGracePeriodSeconds: 30
      initContainers:
        {{- if .Values.dbMigrateWait.enabled }}
        - name: {{ .Values.dbMigrateWait.image.name }}
          {{- if .Values.dbMigrateWait.securityContext }}
          securityContext:
            {{- toYaml .Values.dbMigrateWait.securityContext | nindent 12 }}
          {{- end }}
          {{- if eq .Values.dbMigrateWait.image.repository "local" }}
          image: "{{ .Values.dbMigrateWait.image.name }}:{{ .Values.dbMigrateWait.image.tag }}"
          {{- else }}
          image: "{{ .Values.dbMigrateWait.image.repository }}:{{ .Values.dbMigrateWait.image.tag }}"
          {{- end }}
          imagePullPolicy: {{ .Values.dbMigrateWait.image.pullPolicy }}
          {{- if .Values.dbMigrateWait.resources }}
          resources:
            {{- toYaml .Values.dbMigrateWait.resources | nindent 12 }}
          {{- end }}
          {{- if .Values.saVolumeMounts }}
          volumeMounts:
            {{- toYaml .Values.saVolumeMounts | nindent 12 }}
          {{- end }}
          args:
            - "wait"
            - "--for=condition=complete"
            - "--timeout=1h"
            - "job/{{ include "dsccservice.dbMigrate.Name" . }}"
        {{- end }}
      containers:
        - name: {{ .Values.grpc.container.image.name }}
          securityContext:
            {{- toYaml .Values.grpc.container.securityContext | nindent 12 }}
          image: "dsccjob:development"
          imagePullPolicy: Never  
          command:
          - /busybox/sh
          - -c
          - |
            echo "Container started and holding..." && tail -f /dev/null
          ports:
            - containerPort: {{ .Values.service.ssobroker.grpcPort }}
            - containerPort: {{ .Values.service.ssobroker.grpcPrivatePort }}
          {{- if .Values.grpc.container.resources }}
          resources:
            {{- toYaml .Values.grpc.container.resources | nindent 12 }}
          {{- end }}
          {{- if .Values.grpc.container.liveness }}
          livenessProbe:
            {{- toYaml .Values.grpc.container.liveness | nindent 12}}
          {{- end }}
          {{- if .Values.grpc.container.readiness }}
          readinessProbe:
            {{- toYaml .Values.grpc.container.readiness | nindent 12}}
          {{- end }}
          env:
          {{- include "dsccservice.envVars" .Values.common.env.grpc | nindent 10}}
          volumeMounts:
            {{- if .Values.saVolumeMounts }}
              {{- toYaml .Values.saVolumeMounts | nindent 12 }}
            {{- end }}
            - name: service-discovery
              mountPath: /etc/ops-config
            - name: app-config
              mountPath: /etc/app-config
            - name: app-onboarding
              mountPath: /etc/onboard-config
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
        - name: app-onboarding
          configMap:
            name: sc-ops-app-onboarding
            items:
              - key: oauth_well_known_endpoint
                path: ccsauth/oauth_well_known_endpoint
        - name: app-config
          configMap:
            name: {{ include "dsccservice.grpc.Name" . }}
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/name
                    operator: In
                    values:
                      - {{ include "dsccservice.grpc.Name" . }}
              topologyKey: kubernetes.io/hostname
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/name
                    operator: In
                    values:
                      - {{ include "dsccservice.grpc.Name" . }}
              topologyKey: topology.kubernetes.io/zone
          - weight: 90
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/name
                    operator: In
                    values:
                      - {{ include "dsccservice.grpc.Name" . }}
              topologyKey: kubernetes.io/hostname
{{- end -}}
{{- end }}
