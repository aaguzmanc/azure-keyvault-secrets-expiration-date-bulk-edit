#!/bin/bash

#ObjectId for Service Principal or User runninng the script, it is necesary to grant access to the KeyVaylt secrets this can be obtained 
#from Azure AD - User - UserX - Object ID - paste the ID below:
export uid="bxxxx-0000-0x00-00c0-6xxxxxxxx";

#Get KeyVault Names
vlts=$(az keyvault list --output tsv --query "[].name")
#Iterate each KeyVault
for vl in $vlts
do
  echo -e "\nVault: $vl\n"
  # Add Access to Vault for User or Service Principal runninng this script so he an modify Secrets
	az keyvault set-policy --name $vl --object-id $uid --secret-permissions all --output table
#Get secrets
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
