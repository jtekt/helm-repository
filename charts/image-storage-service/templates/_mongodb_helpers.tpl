{{/* CURRENTLY HARD CODED */}}
{{- define "image-storage-service.mongodb.connectionString" -}}
  {{ $externalconnectionString := default ((.Values.global).mongodb).connectionString (.Values.mongodb).connectionString -}}
  {{- if $externalconnectionString -}}
    {{ $externalconnectionString }}
  {{- else -}}
    {{ $mongodbName := "mongodb" }}
    {{- printf "mongodb://%s-%s/image_storage" .Release.Name $mongodbName }}
  {{- end -}}
{{- end -}}