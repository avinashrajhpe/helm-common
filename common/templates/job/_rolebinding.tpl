{{ define "common.job.rolebinding" }}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dsccjob-rolebinding
  namespace: {{ .Release.Namespace }}
subjects:
  - kind: ServiceAccount
    name: {{ .Values.serviceAccount.name }}
    namespace: {{ .Release.Namespace }}
roleRef:
  kind: Role
  name: dsccjob-role
  apiGroup: rbac.authorization.k8s.io
{{- end }}