#Get KeyVault Names
vlts=$(az keyvault list --output tsv --query "[].name")
#Iterate each KeyVault
for vl in $vlts
do
  echo -e "\nVault: $vl\n"
#Get secrets
    vsecs=$(az keyvault secret list --output tsv --query "[].name" --vault-name $vl)
#Iterate Secrets
     for vs in $vsecs
     do
      expdate=$(az keyvault secret show --name $vs  --vault-name $vl --query "{Secret:name, ExpirationDate:attributes.expires}" --output tsv)
#Display Secret Name and Expiration Date	 
	  echo -e "\nExpiration: $expdate\n"
	 done
done
