// Copyright 2024-2025 Hewlett Packard Enterprise Development LP
{{/*
Chart name and version as used by the chart label
*/}}
{{- define "dsccservice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Base name of services
*/}}
{{- define "dsccservice.baseName" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 44 | trimSuffix "-" }}
{{- end }}

{{/*
GRPC service name
*/}}
{{- define "dsccservice.grpc.Name" -}}
{{ include "dsccservice.baseName" . -}}-grpc
{{- end }}


{{/*
DB migrate job name
*/}}
{{- define "dsccservice.dbMigrate.Name" -}}
{{ include "dsccservice.baseName" . -}} -db-migrate- {{- .Chart.AppVersion | replace "." "-" }}
{{- end }}

{{/*
Common service labels
*/}}
{{- define "dsccservice.common.ServiceLabels" -}}
helm.sh/chart: {{ include "dsccservice.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ include "dsccservice.baseName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dsccservice.common.Labels" -}}
{{ include "dsccservice.common.ServiceLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
GRPC service selector labels
*/}}
{{- define "dsccservice.grpc.SelectorLabels" -}}
app.kubernetes.io/name: {{ include "dsccservice.grpc.Name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
DB migrate job selector labels
*/}}
{{- define "dsccservice.dbMigrate.SelectorLabels" -}}
app.kubernetes.io/name: {{ include "dsccservice.dbMigrate.Name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
GRPC service labels
*/}}
{{- define "dsccservice.grpc.Labels" -}}
{{ include "dsccservice.common.ServiceLabels" . }}
{{ include "dsccservice.grpc.SelectorLabels" . }}
app: {{ include "dsccservice.grpc.Name" . }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}


{{/*
DB migrate job labels
*/}}
{{- define "dsccservice.dbMigrate.Labels" -}}
{{ include "dsccservice.common.ServiceLabels" . }}
{{ include "dsccservice.dbMigrate.SelectorLabels" . }}
app: {{ include "dsccservice.dbMigrate.Name" . }}
{{- end }}

{{/*
SSO Broker environment variables
*/}}
{{- define "dsccservice.envVars" -}}
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

{{- define "dsccservice.grpc.HpaName" -}}
{{ include "dsccservice.grpc.Name" . -}} -hpa
{{- end -}}

{{- define "dsccservice.grpc.pdbName" -}}
{{ include "dsccservice.grpc.Name" . -}} -pdb
{{- end -}}