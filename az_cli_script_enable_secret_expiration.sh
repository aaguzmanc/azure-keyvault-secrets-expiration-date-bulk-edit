#!/bin/bash
#SRIPT TO SET EXPIRATION DATE ON KEVVAULT SECRETS MASSIVELY - By AG
#THIS SCRIPT ADD THE REQUIERED PERMISSIONS TO MODIFY SECRETS AND THE REMOVE THOSE PERMISSIONS - ONLY NULL EXIRTION DATE WILL BE SELECTED
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
#Get secrets without expiration date (expiration date == null) from each KeyVault
    vsecs=$(az keyvault secret list --output tsv --query "[?attributes.expires == null].{Name:name}" --vault-name $vl)
#Iterate Secrets
	 for vs in $vsecs
     do
      echo -e "\nSecret: $vs\n"
#Enable and set Expiration Date	  ********** BELOW YOU SHOULD SET YOUR DESIRED EXPIRATION DTAE FOR SECRETS - THIS WILL BE APPLIED TO ALL SECRETs MASSIVELY!
	  az keyvault secret set-attributes --expires "2025-10-30" --vault-name $vl -n $vs
	  echo "\nExpiration set for: $vs\n"
	 done
# Remove Access to Vaul for User or Service Principal runninng this script	
	az keyvault set-policy --name $vl --object-id $uid --secret-permissions --output table
done
