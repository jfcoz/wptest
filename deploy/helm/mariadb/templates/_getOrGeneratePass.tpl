{{/*
Read existing secret, or use value, or generate
usage:
  MARIADB_PASSWORD: {{
    include "getOrGeneratePass"
      ( dict
        "Namespace" .Release.Namespace
        "Kind" "Secret"
        "Name" (include "mariadb.fullname" .)
        "Key" "MARIADB_PASSWORD"
        "Default" .Values.Password
      )
    }}
*/}}
{{- define "getOrGeneratePass" }}
{{- $len := (default 16 .Length) | int -}}
{{- $obj := (lookup "v1" .Kind .Namespace .Name).data -}}
{{- if $obj }}
{{- index $obj .Key -}}
{{- else if (eq (lower .Kind) "secret") -}}
{{- default (randAlphaNum $len) .Default | b64enc -}}
{{- else -}}
{{- default (randAlphaNum $len) .Default | quote -}}
{{- end -}}
{{- end }}

