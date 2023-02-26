{{/*
Resource name
*/}}
{{- define "annotation-tool.prefix" -}}
  {{- printf "%s-%s" .Release.Name .Chart.Name  }}
{{- end }}

{{/*
API URL
Unless anything provided, defaults to {release}-iss-api
If iss.api.url is provided, use that
*/}}
{{- define "annotation-tool.apiUrl" -}}
  {{- if (.Values.iss).url }}
    {{- .Values.iss.url }}
  {{- else -}}
    http://{{- printf "%s-%s" .Release.Name "iss-api" | trunc 63 | trimSuffix "-" }}
  {{- end }}
{{- end }}