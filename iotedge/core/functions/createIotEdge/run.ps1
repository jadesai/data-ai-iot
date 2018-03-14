# read function input parameters passed by CIQS
$input = (Get-Content $req) -join "`n" | ConvertFrom-Json

$arm = "https://management.azure.com"
$iot = "https://main.iothub.ext.azure.com"
$authtoken = $input.authtoken
$iothub = $input.iothub
$resgrp = $input.resgrp
$subs = $input.subs

# Create keys
$uri = "$arm/subscriptions/$subs/resourceGroups/$resgrp/providers/Microsoft.Devices/IotHubs/$iothub/listKeys?api-version=2017-07-01"
$resp = Invoke-RestMethod "$uri" -Method POST -Body "" -ContentType "application/json" -Headers @{"Authorization"="Bearer $authtoken"}

# Read key
$rkey = $resp.value[0].primaryKey
$key = [System.Web.HttpUtility]::UrlEncode($rkey) 

# Create edge device
$uri = "$iot/api/Devices/Create/?hostname=$iothub.azure-devices.net&owner=iothubowner&key=$key&deviceId=$resgrp&enabled=true&edgeEnabled=true&authMethod=1&deviceKey1=&deviceKey2="
$resp = Invoke-RestMethod "$uri" -Method PUT -Body "" -ContentType "application/json" -Headers @{"Authorization"="Bearer $authtoken"}

# Fetch connection string
$qry = "SELECT%20*%20FROM%20devices%20WHERE%20deviceId%20%3D%20%27$resgrp%27&take=10&_=" + ([int32]::MaxValue + (Get-Random))
$uri = "$iot/api/Devices/ExecuteTwinQuery/?hostname=$iothub.azure-devices.net&owner=iothubowner&key=$key&queryString=$qry"
$resp = Invoke-RestMethod "$uri" -Method GET -ContentType "application/json" -Headers @{"Authorization"="Bearer $authtoken"}
$connKey = $resp.Devices[0].device.authentication.symmetricKey.primaryKey
$connstr = "HostName=$iothub.azure-devices.net;DeviceId=$resgrp;SharedAccessKey=$connKey"

$output = @{ "deviceconnectionstring" = $connstr; "devicekey" = $rkey }
$output | ConvertTo-Json | Out-File $res