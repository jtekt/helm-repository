{{/*
Prefix for resources.
*/}}
{{- define "image-storage-service.prefix" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Ingress host
*/}}
{{- define "image-storage-service.ingress.host" -}}
{{- .Values.ingress.host }}
{{- end }}


