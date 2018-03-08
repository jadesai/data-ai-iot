# read function input parameters passed by CIQS
$input = (Get-Content $req) -join "`n" | ConvertFrom-Json

$arm = "https://management.azure.com"
$iot = "https://main.iothub.ext.azure.com"
$authtoken = $input.authtoken
$iothub = $input.iothub
$resgrp = $input.resgrp
$subs = $input.subs
$devkey = $input.devicekey
$tsi = $input.tsiname
$location = $input.location

$postdata = @{
	"location"= "$location",
	"kind"= "Microsoft.IoTHub",
	"properties"= @{
		"iotHubName"= "$iothub",
		"keyName"= "iothubowner",
		"sharedAccessKey"= "$devkey",
		"consumerGroupName"= "`$Default",
		"eventSourceResourceId"= "/subscriptions/$subs/resourceGroups/$resgrp/providers/Microsoft.Devices/IotHubs/$iothub",
		"localTimestamp"= $null
	}
}

$url = "$arm/subscriptions/$subs/resourceGroups/$resgrp/providers/Microsoft.TimeSeriesInsights/environments/$tsi/eventsources/$resgrp?api-version=2017-11-15"
$body = $postdata | Convertto-Json
$resp = Invoke-RestMethod "$uri" -Method POST -Body $body -ContentType "application/json" -Headers @{"Authorization"="Bearer $authtoken"}