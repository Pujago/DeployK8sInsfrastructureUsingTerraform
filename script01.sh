            #!/bin/bash
            VAULT_NAME=keyvault-tstate$RANDOM
            RESOURCE_GROUP_NAME=tstate
            STORAGE_ACCOUNT_NAME=tstate$RANDOM
            CONTAINER_NAME=tstate
            

            echo "#################### Create Resource Group ##################"
            # Create resource group
            az group create --name $RESOURCE_GROUP_NAME --location "australiaeast"
            
            echo "#################### Create Storage Account ##################"
            # Create storage account
            az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
            
            echo "#################### Assign storage account keys ##################"
            # Get storage account key
            ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
            
            echo "#################### Create Storage Container ##################"
            # Create blob container
            az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
            
            echo "#################### Create Key Vault ##################"
            # Create Azure Key Vault
            az keyvault create -n $VAULT_NAME -g $RESOURCE_GROUP_NAME -l "australiaeast"
            
            echo "#################### Create Secrets ##################"
            #Create Kevault Secret
            az keyvault secret set --vault-name $VAULT_NAME --name "sa-access-key" --value $ACCOUNT_KEY
            
            az keyvault secret set --vault-name $VAULT_NAME --name "client-secret" --value "xxxxxxxxxxxxxxxxxxxxxxx"

            az keyvault secret set --vault-name $VAULT_NAME --name "client-id" --value "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"

            az keyvault secret set --vault-name $VAULT_NAME --name "tenant-id" --value "xxxxxxxxxxxxxxxxxxxxxxxxx"

            az keyvault secret set --vault-name $VAULT_NAME --name "subscription-id" --value "xxxxxxxxxxxxxxxxxxxxxxxxxx"
            
            echo "#################### Allow SPN to access key vault ##################"
            #Allow SPN to access key vault
            az keyvault set-policy --name $VAULT_NAME --spn "xxxxxxxxxxxxxxxxxxxxxx" --secret-permissions get list  

            echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
            echo "container_name: $CONTAINER_NAME"
            echo "access_key: $ACCOUNT_KEY"
            echo "Key Vault: $VAULT_NAME"
            
            # Replace xxxxxx values with your client id, secret, tenant id. 
            # echo "Delete resource group"
            # az group delete -n $RESOURCE_GROUP_NAME