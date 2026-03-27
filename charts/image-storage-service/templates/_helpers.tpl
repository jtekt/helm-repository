{{/*
Expand the name of the chart.
*/}}
{{- define "image-storage-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "image-storage-service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "image-storage-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "image-storage-service.labels" -}}
helm.sh/chart: {{ include "image-storage-service.chart" . }}
{{ include "image-storage-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "image-storage-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "image-storage-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Fully qualified name for the API component.
*/}}
{{- define "image-storage-service.api.fullname" -}}
{{- printf "%s-api" (include "image-storage-service.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified name for the GUI component.
*/}}
{{- define "image-storage-service.gui.fullname" -}}
{{- printf "%s-gui" (include "image-storage-service.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
MongoDB connection string.
Uses .Values.mongodb.connectionString or .Values.global.mongodb.connectionString if provided,
otherwise constructs an in-cluster connection string to the bundled MongoDB subchart.
*/}}
{{- define "image-storage-service.mongodb.connectionString" -}}
{{- $externalConnectionString := default ((.Values.global).mongodb).connectionString (.Values.mongodb).connectionString -}}
{{- if $externalConnectionString -}}
{{- $externalConnectionString -}}
{{- else -}}
{{- printf "mongodb://%s-mongodb/image_storage" .Release.Name -}}
{{- end -}}
{{- end }}
