{{/* CURRENTLY HARD CODED */}}
{{- define "image-storage-service.mongodb.url" -}}
  {{ $externalUrl := default ((.Values.global).mongodb).url (.Values.mongodb).url -}}
  {{- if $externalUrl -}}
    {{ $externalUrl }}
  {{- else -}}
    {{ $mongodbName := "mongodb" }}
    {{- printf "mongodb://%s-%s" .Release.Name $mongodbName }}
  {{- end -}}
{{- end -}}