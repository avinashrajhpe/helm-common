{{ define "common.job.role" }}
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dsccjob-role
  namespace: {{ .Release.Namespace }}
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["delete", "create", "get", "list"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get","list", "delete","watch"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["jobs"]
  verbs: ["get", "watch", "list"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["get", "watch", "list"]
- apiGroups: ["apps"]
  resources: ["statefulsets"]
  verbs: ["get","watch","list", "patch"]
{{- end }}