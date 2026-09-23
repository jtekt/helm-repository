{{/*
Expand the name of the chart.
*/}}
{{- define "api-key-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "api-key-manager.fullname" -}}
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
{{- define "api-key-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "api-key-manager.labels" -}}
helm.sh/chart: {{ include "api-key-manager.chart" . }}
{{ include "api-key-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "api-key-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "api-key-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Fully qualified name for the API component.
*/}}
{{- define "api-key-manager.api.fullname" -}}
{{- printf "%s-api" (include "api-key-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified name for the GUI component.
*/}}
{{- define "api-key-manager.gui.fullname" -}}
{{- printf "%s-gui" (include "api-key-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified name for the proxy component.
*/}}
{{- define "api-key-manager.proxy.fullname" -}}
{{- printf "%s-proxy" (include "api-key-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified name for the PostgreSQL component.
*/}}
{{- define "api-key-manager.postgresql.fullname" -}}
{{- printf "%s-postgresql" (include "api-key-manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PostgreSQL connection string.
Uses .Values.postgresql.connectionString if provided,
otherwise constructs an in-cluster connection string to the bundled PostgreSQL.
*/}}
{{- define "api-key-manager.postgresql.connectionString" -}}
{{- if .Values.postgresql.connectionString -}}
{{- .Values.postgresql.connectionString -}}
{{- else -}}
{{- $auth := .Values.postgresql.auth -}}
{{- printf "postgres://%s:%s@%s:5432/%s" (urlquery $auth.username) (urlquery $auth.password) (include "api-key-manager.postgresql.fullname" .) $auth.database -}}
{{- end -}}
{{- end }}
