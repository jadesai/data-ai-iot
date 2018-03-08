# read function input parameters passed by CIQS
$input = (Get-Content $req) -join "`n" | ConvertFrom-Json

$arm = "https://management.azure.com/subscriptions"
$iot = "https://main.iothub.ext.azure.com"
$authtoken = $input.authtoken
$iothub = $input.iothub
$resgrp = $input.resgrp
$subs = $input.subs
$devkey = $input.devicekey

$postdata = @{
	"hostName"= "$iothub.azure-devices.net",
	"owner"= "iothubowner",
	"key"= "$devkey",
	"configurationContent"= @{
		"moduleContent"= @{
			"`$edgeAgent"= @{
				"properties.desired"= @{
					"schemaVersion"= "1.0",
					"runtime"= @{
						"type"= "docker",
						"settings"= @{
							"minDockerVersion"= "v1.25",
							"loggingOptions"= ""
						}
					},
					"systemModules"= @{
						"edgeAgent"= @{
							"type"= "docker",
							"settings"= @{
								"image"= "microsoft/azureiotedge-agent:1.0-preview",
								"createOptions"= "{}"
							}
						},
						"edgeHub"= @{
							"type"= "docker",
							"status"= "running",
							"restartPolicy"= "always",
							"settings"= @{
								"image"= "microsoft/azureiotedge-hub:1.0-preview",
								"createOptions"= "{}"
							}
						}
					},
					"modules"= @{
						"tempSensor"= @{
							"version"= "1.0",
							"type"= "docker",
							"status"= "running",
							"restartPolicy"= "always",
							"settings"= @{
								"image"= "microsoft/azureiotedge-simulated-temperature-sensor:1.0-preview",
								"createOptions"= "{}"
							}
						}
					}
				}
			},
			"`$edgeHub"= @{
				"properties.desired"= @{
					"schemaVersion"= "1.0",
					"routes"= @{
						"route"= "FROM /* INTO `$upstream"
					},
					"storeAndForwardConfiguration"= @{
						"timeToLiveSecs"= 7200
					}
				}
			}
		}
	},
	"deviceId"= "$resgrp"
}

$uri = "$iot/api/Devices/ApplyConfigurationContent/";
$body = $postdata | Convertto-Json
$resp = Invoke-RestMethod "$uri" -Method POST -Body $body -ContentType "application/json" -Headers @{"Authorization"="Bearer $authtoken"}