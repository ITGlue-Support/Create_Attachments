###################################################################################################
######### Get IT Glue API Key
###################################################################################################
If($ITG_API -eq $null){
    $ITG_API = Read-Host "Enter your API key" #Ask for the IT Glue API  Key
}
else{
    Write-Host "Using existing API:" $ITG_API
}
###################################################################################################
######### API Headers
###################################################################################################

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("x-api-key", "$ITG_API")
$headers.Add("Content-Type", "application/vnd.api+json")

###################################################################################################
######### Collect the CSV file for the document ID from previous MSP export
###################################################################################################

$path = Read-Host "Enter the file path for configuration.csv received from other MSP"
$CSVData = Import-Csv -Path $path
$document_remote_instance = $CSVData | Group-Object -Property ID

###################################################################################################
######### Check if the document ID and attachment associated to the document
###################################################################################################

$Attachmentspath = Read-Host "Enter the file path for (attachments > Document) received from other MSP export.zip"

###################################################################################################
######### 
###################################################################################################

Foreach ($docinfo in $document_remote_instance.Group){
$checkr8folder = Get-ChildItem $Attachmentspath | Where-Object {$_.Name -eq $($docinfo.id)}
If($checkr8folder){
$file_name = (Get-ChildItem "$Attachmentspath\$checkr8folder" | Where-Object {$_.Name}).Name

###################################################################################################
######### Conversion of the document to encode base64
###################################################################################################

$base64 = [System.Convert]::ToBase64String((Get-Content -Path "$Attachmentspath\$($docinfo.id)\$file_name"-encoding byte))

###################################################################################################
######### Fectch the conifguration in IT Glue instance
###################################################################################################
try{
$ConfigURL = "https://api.itglue.com/configurations?filter[name]=$($docinfo.name)&page[size]=1000"
$configlist = Invoke-RestMethod $ConfigURL -Method 'GET' -Headers $Headers
$config_data=$configlist.data
$config_id = $configlist.data.id
if($config_data.id.count -gt 1){
			Write-Host "Found multiple configurations with name:" $($docinfo.name) -ForegroundColor red
			Write-Host "Checking for Org to narrow down the search" -ForegroundColor yellow
			foreach($item in $config_data){
				if($docinfo.organization -eq $item.attributes.'organization-name'){
					$config_id = $item.id
					Write-Host "Uploading the attachment into org name: "$item.attributes.'organization-name'
					Write-Host "Attaching file $file_name to the document with ID: "$item.id

				}
				
			}
}

Write-Host "Match found for the configuration:" $($conifiglist.data.attribute.name) -ForegroundColor yellow

Write-Host "creating the attachment:" $file_name -ForegroundColor yellow
}
catch{
    "Configuration with the name $($docinfo.name) not found!"
}
###################################################################################################
######### Create an attachment
###################################################################################################

$body = @"
{
  `"data`": {
    `"type`": `"attachments`",
    `"attributes`": {
      `"attachment`": {
        `"content`": `"$base64`",
        `"file_name`": `"$file_name`"
      }
    }
  }
}
"@


$response = Invoke-RestMethod "https://api.itglue.com/configurations/$config_id/relationships/attachments" -Method 'POST' -Headers $headers -Body $body
Write-Host "Match found for the configuration:" $($conifiglist.data.attribute.name) -ForegroundColor yellow

Write-Host "creating the attachment:" $file_name -ForegroundColor yellow
Write-Host "Document attached successfully!!" -ForegroundColor Green


}
}


