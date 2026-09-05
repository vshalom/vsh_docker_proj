{{- define "vsh-docker-proj.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}
