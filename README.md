#Vaccination Alert
Poll the [UK NHS vaccinations site](https://www.nhs.uk/conditions/coronavirus-covid-19/coronavirus-vaccination/book-coronavirus-vaccination/") and alert me when the minimum required age allows me to book a vaccination.

## Infrastructure Deployment
Deploy using [Terraform](https://registry.terraform.io/) to AWS. Ensure you have an AWS account created, and your credentials stored locally, then create infrastructure using
```commandline
cd infrastructure
tf apply
```

## Building the Container
To build and push the container run
```commandline
docker build -t vaccination_alert .
docker tag vaccination_alert:latest 295760464315.dkr.ecr.eu-west-2.amazonaws.com/vaccination_alert:latest
 docker push 295760464315.dkr.ecr.eu-west-2.amazonaws.com/vaccination_alert:latest
```

## Running
Every 6 hours an EventBridge Rule will trigger a task running on Fargate to scrape the site and notify me via SMS if I'm not eligible to book a vaccination.