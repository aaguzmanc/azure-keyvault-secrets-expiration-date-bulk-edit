#!/bin/bash
#SRIPT TO VALIDATE EXPIRATION DATE ON KEYVAULT SECRETS - By AG
#SECRETS EXPIRATION IS REQUIRED TO COMPLY WITH CIS AZURE FOUNDATIONS BENCHMARK V1.4 - CONTROLS 8.3 AND 8.4

#ObjectId for Service Principal or User signed in to run the script, it is necesary to grant access to the KeyVaylt secrets this user must have priviledges to manage KeyVaults
uid=$(az ad signed-in-user show --query "[id]" --output tsv)

#Get KeyVault Names
vlts=$(az keyvault list --output tsv --query "[].name")
#Iterate each KeyVault
for vl in $vlts
do
  echo -e "\nVault: $vl\n"
  # Add Access to Vault for User or Service Principal runninng this script so he an modify Secrets
	az keyvault set-policy --name $vl --object-id $uid --secret-permissions all --output table
#Get secrets from each KeyVault
    vsecs=$(az keyvault secret list --output tsv --query "[].name" --vault-name $vl)
#Iterate Secrets
     for vs in $vsecs
     do
      expdate=$(az keyvault secret show --name $vs  --vault-name $vl --query "{Secret:name, ExpirationDate:attributes.expires}" --output tsv)
#Display Secret Name and Expiration Date	 
	  echo -e "\nExpiration: $expdate\n"
	 done
  # Remove Access to Vaul for User or Service Principal runninng this script	
	az keyvault set-policy --name $vl --object-id $uid --secret-permissions --output table
done
