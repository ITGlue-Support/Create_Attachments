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

$path = Read-Host "Enter the file path for document.csv received from other MSP"
$CSVData = Import-Csv -Path $path
$document_remote_instance = $CSVData | Group-Object -Property ID

###################################################################################################
######### Supply the document with ID and Name from your IT Glue instance
###################################################################################################

$path = Read-Host "Enter the file path for document.csv from your instance"
$CSVData = Import-Csv -Path $path
$document_local_instance = $CSVData | Group-Object -Property ID

###################################################################################################
######### Check if the document ID and attachment associated to the document
###################################################################################################
$Attachmentspath = Read-Host "Enter the file path for (attachments > Document) received from other MSP export.zip"

Foreach ($docinfo in $document_remote_instance.Group){
$checkr8folder = Get-ChildItem $Attachmentspath | Where-Object {$_.Name -eq $($docinfo.id)}
If($checkr8folder){
$file_name = (Get-ChildItem "$Attachmentspath\$checkr8folder" | Where-Object {$_.Name}).Name

###################################################################################################
######### Conversion of the document to encode base64
###################################################################################################

$base64 = [System.Convert]::ToBase64String((Get-Content -Path "$Attachmentspath\$($docinfo.id)\$file_name"-encoding byte))

###################################################################################################
######### Match the document name from CSV and retrieve the document ID
###################################################################################################
Foreach($localdocinfo in $document_local_instance.Group){
	$remote_document_name = $docinfo.name
	$local_document_name = $localdocinfo.name
	if($local_document_name -eq $remote_document_name){
		$document_id = $localdocinfo.id
		if($document_id -gt 1){
			Write-Host "Found multiple documents with name:" $local_document_name
			Write-Host "Checking for Org to narrow down the search"
			foreach($id in $document_id){
				if($docinfo.organization -eq $localdocinfo.organization){
					$document_id = $id
					Write-Host "Uploading the document into org name: "$localdocinfo.organization
					Write-Host "Attaching file "$file_name" to the document with ID: "$id

				}
				
			}

		}
		
		Write-Host "Match found for the document:" $local_document_name -ForegroundColor yellow


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

$response = Invoke-RestMethod "https://api.itglue.com/documents/$document_id/relationships/attachments" -Method 'POST' -Headers $headers -Body $body

Write-Host "Document attached successfully!!" -ForegroundColor Green

}

}
}
else{
	Write-Host "No attachments for the document: " $docinfo.name -ForegroundColor red
}
}
