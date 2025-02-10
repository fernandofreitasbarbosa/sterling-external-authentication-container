{{- /*
Chart specific config file for SCH (Shared Configurable Helpers)
_sch-chart-config.tpl is a config file for the chart to specify additional
values and/or override values defined in the sch/_config.tpl file.

*/ -}}

{{- /*
"sch.chart.config.values" contains the chart specific values used to override or provide
additional configuration values used by the Shared Configurable Helpers.
*/ -}}
{{- define "ibm-seas.sch.chart.config.values" -}}
sch:
  chart:
    appName: "ibm-seas"
    metering:
     {{- if eq (toString .Values.licenseType | lower) "non-prod"  }}
      productName: "IBM Sterling External Authentication Server Premium Ed Certified Container"
      productID: "1eb57e71e4ca4500bf22604fc7452a6f"
    {{- else }}
      productName: "IBM Sterling External Authentication Server Premium Ed Certified Container"
      productID: "1eb57e71e4ca4500bf22604fc7452a6f"
    {{- end }}
      productVersion: "6.1"
      productMetric: "VIRTUAL_PROCESSOR_CORE"
      productChargedContainers: ""
    podSecurityContext:
      runAsNonRoot: true
      supplementalGroups: {{ .Values.storageSecurity.supplementalGroups | default 65534 }} 
      fsGroup: {{ .Values.storageSecurity.fsGroup | default 65534 }}
      runAsUser: 1000
      runAsGroup: 0
    initContainerSecurityContext:
      privileged: false
      runAsUser: 1000
      readOnlyRootFilesystem: false
      allowPrivilegeEscalation: true
      capabilities:
        drop: [ "ALL" ]
        add: [ "DAC_OVERRIDE", "SETGID" ]
    containerSecurityContext:
      privileged: false
      runAsUser: 1000
      readOnlyRootFilesystem: false
      allowPrivilegeEscalation: false
      capabilities:
        drop: [ "ALL" ]
{{- end -}}
