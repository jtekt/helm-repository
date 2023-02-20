{{/*
Prefix for resources.
*/}}
{{- define "image-storage-service.prefix" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Ingress host
To be overwritten by parent chart if necessary
*/}}
{{- define "image-storage-service.ingress.host" -}}
{{- .Values.ingress.host }}
{{- end }}


{{/*
The MongoDB URL, whether internal or external
using global because setting URL of subchart using define override
*/}}
{{- define "image-storage-service.mongodb.url" -}}
{{- if .Values.global.mongodb.url }}
{{- .Values.global.mongodb.url }}
{{- else -}}
mongodb://{{ include "image-storage-service.prefix" . }}-db
{{- end }}
{{- end }}

