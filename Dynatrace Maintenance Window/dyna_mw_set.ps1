# Set your Dynatrace API token and environment URL
$apiToken = "dt0c01."
$environmentUrl = "https://tenant.live.dynatrace.com/api/v2/settings/objects?schemaIds=builtin%3Aalerting.maintenance-window&fields=objectId%2Cvalue"

# Define the maintenance window configuration
$maintenanceWindowConfig = @'
[
    {
        "scope": "environment",
        "schemaId": "builtin:alerting.maintenance-window",
        "schemaVersion": "2.14.2",
        "value": {
            "enabled": true,
            "generalProperties": {
                "name": "Maintenance windows",
                "description": "Maintenance windows are typically planned, recurring periods of system downtime during which your DevOps team can perform preventative maintenance and system upgrades outside of peak traffic hours.",
                "maintenanceType": "UNPLANNED",
                "suppression": "DONT_DETECT_PROBLEMS",
                "disableSyntheticMonitorExecution": true
            },
            "schedule": {
                "scheduleType": "ONCE",
                "onceRecurrence": {
                    "startTime": "2023-07-25T13:45:00",
                    "endTime": "2023-08-22T14:45:00",
                    "timeZone": "Europe/Vienna"
                }
            },
            "filters": [
                {
                    "entityType": "PROCESS_GROUP",
                    "entityId": "PROCESS_GROUP",
                    "entityTags": [],
                    "managementZones": [
                      "Name of- Mgmt Zone"
                    ]
                }
            ]
        }
    }
]
'@

# Make the API call to create the maintenance window
$response = Invoke-RestMethod -Uri "$environmentUrl/maintenanceWindows" -Method Post -Headers @{
    "Authorization" = "Api-Token $apiToken"
    "Content-Type" = "application/json"
} -Body $maintenanceWindowConfig

# Check the response
if ($response) {
    Write-Host "Maintenance window created successfully. ID: $($response.id)"
} else {
    Write-Host "Failed to create maintenance window"
}
