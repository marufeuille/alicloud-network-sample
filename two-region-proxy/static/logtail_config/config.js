{
  "filePattern": "access.log",
  "filterKey": [],
  "filterRegex": [],
  "key": [
    "time",
    "duration",
    "client_addr",
    "result_code",
    "byte",
    "request_method",
    "target",
    "hierarchy_code"
  ],
  "localStorage": true,
  "logBeginRegex": ".*",
  "logPath": "/var/log/squid",
  "logType": "common_reg_log",
  "preserve": true,
  "preserveDepth": 0,
  "priority": 0,
  "regex": "([0-9.]+)\\s+(\\d+)\\s+(\\d+\\.\\d+\\.\\d+\\.\\d+)\\s+([A-Z_/0-9]+)\\s+(\\d+)\\s+(\\w+)\\s+([\\w.:/-_]+)\\s+-\\s+([\\w/_.]+).*",
  "timeFormat": ""
}
