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
      echo -e "\nSecret: $vs\n"
#Enable and set Expiration Date	  
	  az keyvault secret set-attributes --expires "2025-10-30" --vault-name $vl -n $vs
	  echo "\nExpiration set for: $vs\n"
	 done
done
