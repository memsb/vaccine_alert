import bs4
import requests
import boto3
import sys

target_age = int(sys.argv[1])

url = "https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/"
source = requests.get(url).text
soup = bs4.BeautifulSoup(source, 'html.parser')

text = soup.select('#maincontent > article > div > div > section:nth-child(2) > ul > li:nth-child(1)')[0].text
age = [int(s) for s in text.split() if s.isdigit()][0]

if age <= target_age:
    client = boto3.client('sns')
    client.publish(
        TopicArn='arn:aws:sns:eu-west-2:295760464315:vaccine_available',
        Message=f"The vaccination age has now been lowered to {age}",
        Subject='Vaccination now available'
    )
else:
    print(f"Current requirements: {text}")

