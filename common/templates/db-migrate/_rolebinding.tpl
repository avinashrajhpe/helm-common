{{ define "common.dbmigrate.rolebinding" }}
# This role binding is to allow the initContainer to wait on the db migration job.
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: waitfor-db-migrate-job-rolebinding
  namespace: {{ .Release.Namespace }}
subjects:
  - kind: ServiceAccount
    name: {{ .Values.serviceAccount.name }}
    namespace: {{ .Release.Namespace }}
roleRef:
  kind: Role
  name: waitfor-db-migrate-job-role
  apiGroup: rbac.authorization.k8s.io
{{- end }}