#!/bin/bash

ENV=$1

cd environments/$ENV
terraform init
terraform plan