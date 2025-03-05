# Create_Attachments
**Document:**

The PowerShell script in this repository will assist you to create an attachment for the assets in case of onboarding a new client into your IT Glue instance from another MSP IT Glue instance.
Refer to the article at https://api.itglue.com/developer/ for all attributes that are supported and that you need to specify in the script

The base URL for all endpoints and methods is: https://api.itglue.com

Partners with an account in the EU data center will use: https://api.eu.itglue.com

Partners with an account in the Australia data center will use: https://api.au.itglue.com

Pre-requisite:

1. Partner should have the document.csv received from the other MSP. This should be located in the export.zip file received by the other MSP

![image](https://github.com/user-attachments/assets/f3e6630a-19db-47a7-8766-9c219f72542a)

2. Partner needs to first import the documents into their IT Glue instance for the script to be able to add attachments
3. Document.csv from your instance for the ID of the same documents from your instance. You can export it by leveraging the export data feature - https://help.itglue.kaseya.com/help/Content/1-admin/import-and-export/exporting-and-backing-up-account-data.html?Highlight=Export%20Data
4. Path to the attachment folder from the export.zip folder. Make sure to copy the path for the document folder for creating an attachment for documents.
![image](https://github.com/user-attachments/assets/29a0b124-0685-43a1-a521-21867eed4d03)

**Configuration:**

The PowerShell script in this repository will assist you to create an attachment for the assets in case of onboarding a new client into your IT Glue instance from another MSP IT Glue instance.
Refer to the article at https://api.itglue.com/developer/ for all attributes that are supported and that you need to specify in the script

The base URL for all endpoints and methods is: https://api.itglue.com

Partners with an account in the EU data center will use: https://api.eu.itglue.com

Partners with an account in the Australia data center will use: https://api.au.itglue.com

Pre-requisite:

1. Partner should have the configuation.csv received from the other MSP. This should be located in the export.zip file received by the other MSP
2. Partner needs to first import the documents into their IT Glue instance for the script to be able to add attachments
3. Path to the attachment folder from the export.zip folder. Make sure to copy the path for the configuration folder for creating an attachment.

Disclaimer:

The information provided hereby IT Glue is for general informational purposes only. All information is provided in good faith, however, we make no representations or warranties of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability, or completeness of any information provided.

Under no circumstances shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of the information provided here. Your use of this information is solely at your own risk.
