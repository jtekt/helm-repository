{{/*
Prefix for resources.
*/}}
{{- define "image-storage-service.prefix" -}}
  {{ $name := default .Chart.Name .Values.nameOverride }}
  {{- printf "%s-%s" .Release.Name $name -}}
{{- end }}

