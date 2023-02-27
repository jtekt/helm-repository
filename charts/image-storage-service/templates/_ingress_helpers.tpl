
{{- define "image-storage-service.ingress.host" -}}
  {{- $host := default ((.Values.global).ingress).host (.Values.ingress).host -}}
  {{- $subdomain := (.Values.ingress).subdomain -}}
  {{- if $subdomain -}}
    {{- printf "%s.%s" $subdomain $host -}}
  {{- else -}}
    {{ $host }}
  {{- end -}}
{{- end -}}

{{- define "image-storage-service.ingress.enabled" -}}
  {{- default ((.Values.global).ingress).enabled (.Values.ingress).enabled -}}
{{- end -}}

{{- define "image-storage-service.ingress.annotations" -}}
  {{ $annotations := default ((.Values.global).ingress).annotations (.Values.ingress).annotations }}
  {{- with $annotations }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}