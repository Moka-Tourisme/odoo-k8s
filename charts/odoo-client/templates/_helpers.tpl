{{/*
Expand the name of the chart.
*/}}
{{- define "odoo-client.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odoo-client.fullname" -}}
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
{{- define "odoo-client.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odoo-client.labels" -}}
helm.sh/chart: {{ include "odoo-client.chart" . }}
{{ include "odoo-client.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/client: {{ .Values.client.name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odoo-client.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odoo-client.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "odoo-client.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odoo-client.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database host
*/}}
{{- define "odoo-client.dbHost" -}}
{{- printf "%s-postgresql-rw.%s.svc.cluster.local" (include "odoo-client.fullname" .) .Release.Namespace }}
{{- end }}

{{/*
Database name
*/}}
{{- define "odoo-client.dbName" -}}
{{- printf "%s_db" .Values.client.name | replace "-" "_" }}
{{- end }}
