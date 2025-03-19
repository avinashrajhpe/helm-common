// Copyright 2025 Hewlett Packard Enterprise Development LP
{{/*
Chart name and version as used by the chart label
*/}}
{{- define "dsccjob.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Base name of services
*/}}
{{- define "dsccjob.baseName" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 44 | trimSuffix "-" }}
{{- end }}

{{/*
DSCC job name
*/}}
{{- define "dsccjob.Name" -}}
{{ include "dsccjob.baseName" . -}} - {{- .Chart.AppVersion | replace "." "-" }}
{{- end }}

{{/*
Common service labels
*/}}
{{- define "dsccjob.common.ServiceLabels" -}}
helm.sh/chart: {{ include "dsccjob.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ include "dsccjob.baseName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
DSCC job selector labels
*/}}
{{- define "dsccjob.SelectorLabels" -}}
app.kubernetes.io/name: {{ include "dsccjob.Name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
DSCC job labels
*/}}
{{- define "dsccjob.Labels" -}}
{{ include "dsccjob.common.ServiceLabels" . }}
{{ include "dsccjob.SelectorLabels" . }}
app: {{ include "dsccjob.Name" . }}
{{- end }}

{{/*
DSCC environment variables
*/}}
{{- define "dsccjob.envVars" -}}
    {{- range $envVarName, $val := . }}
        {{- if kindIs "map" $val }}
- name: {{ $envVarName | quote }}
  valueFrom:
    configMapKeyRef:
      name: {{ required "configMapName (the name of the config map to fetch env var from) must be specified." $val.configMapName | quote }}
      key: {{ required "configMapKey (the key inside the config map to fetch env var from) must be specified." $val.configMapKey | quote }}
        {{- else }}
- name: {{ $envVarName | quote }}
  value: {{ $val | quote -}}
        {{- end }}
    {{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dsccjob.common.Labels" -}}
{{ include "dsccjob.common.ServiceLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}