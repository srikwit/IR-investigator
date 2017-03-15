from ipwhois import IPWhois
from pprint import pprint
import csv
with open("Whois_Output.csv","wb") as csvfile:
	writer = csv.writer(csvfile, delimiter=';', quoting=csv.QUOTE_MINIMAL)
	writer.writerow(['IP Address', 'Org Name', 'Org Country', 'Org Address', 'Description'])
	with open("iplist.txt","r") as f:
		iplst = f.readlines()
		for ip in iplst:
			print ip.strip()	
			obj = IPWhois(ip.strip())
			r = obj.lookup_whois()
			country = r['asn_country_code']
			name = r['nets'][0]['name']
			ad = r['nets'][0]['address']
			desc= r['nets'][0]['description']
			writer.writerow([ip, name, country, ad, desc])
	f.close()
csvfile.close()
		
	
