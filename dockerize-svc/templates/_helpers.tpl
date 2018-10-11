{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "dependencyName" -}}
{{- $depObj := index . 0 -}}
{{- $global := index . 1 -}}
{{- $targetSvc := $depObj.target -}}

{{- range $key,$value := $targetSvc.services -}}
{{- if eq $key $depObj.name -}}
    {{- $svcObj:= $value }}
    {{- if $value.nameOverride -}}
        {{- $value.nameOverride -}}
    {{- else -}}
        {{- default (include "fullname" $global) $targetSvc.fullnameOverride }}-{{ $depObj.name }}
    {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "dependencyPort" -}}
{{- $depObj := index . 0 -}}
{{- $global := index . 1 -}}
{{- $targetSvc := $depObj.target -}}

{{- range $key,$value := $targetSvc.services -}}
{{- if eq $key $depObj.name -}}
    {{- $svcObj:= $value }}
    {{- $portName := default "default" $depObj.port }}
    {{- range $portName,$portObj := $value.ports -}}
        {{- if eq $portName $portName -}}
            {{- $portObj.port -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
