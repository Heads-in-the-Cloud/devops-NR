{{/*
Expand the name of the chart.
*/}}
{{- define "utopia-microservices.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "utopia-microservices.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "utopia-microservices.labels" -}}
helm.sh/chart: {{ include "utopia-microservices.chart" . }}
app: {{ .Release.Name }}
{{ include "utopia-microservices.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "utopia-microservices.selectorLabels" -}}
app.kubernetes.io/name: utopia-{{ .Release.Name }}
{{- end }}
