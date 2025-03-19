{{ define "common.dbmigrate.role" }}
# This role is to allow the initContainer to wait on the db migration job.
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: waitfor-db-migrate-job-role
  namespace: {{ .Release.Namespace }}
rules:
- apiGroups: [""]
  resources: ["jobs"]
  verbs: ["get", "watch", "list"]
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["get", "watch", "list"]
{{- end }}