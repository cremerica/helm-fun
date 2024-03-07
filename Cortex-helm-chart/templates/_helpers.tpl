{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cortex-helm.name" -}}
{{- default .Chart.Name .Values.helmConfiguration.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cortex-helm.fullname" -}}
{{- if .Values.helmConfiguration.fullnameOverride }}
{{- .Values.helmConfiguration.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.helmConfiguration.nameOverride }}
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
{{- define "cortex-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cortex-helm.labels" -}}
helm.sh/chart: {{ include "cortex-helm.chart" . }}
{{ include "cortex-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cortex-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cortex-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Get a hostname from URL
*/}}
{{- define "hostname" -}}
{{- . | trimPrefix "http://" |  trimPrefix "https://" | trimSuffix "/" | quote -}}
{{- end -}}

{{- define "apiPort" -}}
{{- $port := (default dict .Values.app.portForward).api }}
{{- if $port }}
{{- printf ":%d" (int $port) -}}
{{- else -}}
{{- "" -}}
{{- end }}
{{- end }}

{{- define "appPort" -}}
{{- $port := (default dict .Values.app.portForward).app }}
{{- if $port }}
{{- printf ":%d" (int $port) -}}
{{- else }}
{{- "" -}}
{{- end }}
{{- end }}

{{- define "apphost" -}}
{{- $host := required "A valid app host is required" .Values.app.hostnames.frontend -}}
{{- printf "%s" $host}}
{{- end -}}

{{- define "apihost" -}}
{{- $host := required "A valid api host is required" .Values.app.hostnames.backend -}}
{{- printf "%s" $host }}
{{- end -}}


{{- define "appurl" -}}
{{- $apphost := (include "apphost" .)}}
{{- $protocol := required "A valid protocol is required" .Values.app.hostnames.protocol -}}
{{- printf "%s://%s%s" $protocol $apphost (include "appPort" .) | quote -}}
{{- end -}}

{{- define "appurl_noport" -}}
{{- $apphost := (include "apphost" .)}}
{{- $protocol := required "A valid protocol is required" .Values.app.hostnames.protocol -}}
{{- printf "%s://%s" $protocol $apphost | quote -}}
{{- end -}}

{{- define "appurl_unquoted" -}}
{{- $apphost := (include "apphost" .)}}
{{- $protocol := required "A valid protocol is required" .Values.app.hostnames.protocol -}}
{{- printf "%s://%s%s" $protocol $apphost (include "appPort" .) -}}
{{- end -}}

{{- define "apiurl" -}}
{{- $apihost := (include "apihost" .)}}
{{- $protocol := required "A valid protocol is required" .Values.app.hostnames.protocol -}}
{{- printf "%s://%s%s" $protocol $apihost (include "apiPort" .) | quote -}}
{{- end -}}