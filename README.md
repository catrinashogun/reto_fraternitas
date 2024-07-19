<!--
title: 'Fraternitas Challenge'
description: 'This template demonstrates how to deploy a microservice.'
layout: Doc
framework: v1
platform: NodeJS and Terraform
language: Terraform, JavaScript
authorLink: 'https://github.com/catrinashogun'
authorName: 'Alexandro Pequeno'
-->

# Fraternitas Challenge

This project demonstrates a structure that includes two different application layers to deploy a microservice on AWS. Inside this project, you will find a Terraform deployment source project and a JavaScript project meant to be used with API Gateway and AWS Lambda.

## Contents

1. [Components](#components)
2. [Overview](#overview)
3. [Generate an Access Token](#generate-token)
4. [Need Help?](#need-help)

## Components

| Component             |  Version  | 
|:----------------------|:---------:|
| Node.js               | 18.*      | 
| Terraform             | 1.9.*     |  
| Serverless Framework  | 4         |
| Webpack               | 5.93.*    |
| JavaScript            | ES2023    |
| TypeScript            | 5.5.3     |
| Express.js            | ^4.19.2   |

## Overview

To get started, we can call the following endpoint with a simple GET HTTP method:

[**Lambda Public URL**](https://ski6dpfmgiwjb6ol75ecwyor240ufesp.lambda-url.us-east-1.on.aws)

The URL above is for our microservice, and it will return a plain "hello world" response. By saying "to make things easier," we mean that we always want a simple development environment for faster testing scenarios. However, this is not best practice, so a security layer has been added on top of our AWS Lambda for a more secure approach not meant for testing. For this, we have put our function behind **API Gateway** and added a security layer with the help of **Cognito** using client credentials.

To understand more about the architecture of our microservice, let's review the following resource map.

![Resource Map](/lambda_nozip/media/imgs/resource-map.jpg)

- At the top level, we will find the developer. The developer will push changes, starting our code integration process. When a pull request is made to the main branch, an **action** will be triggered to review our Terraform infrastructure and apply the necessary updates.

- Once the first part of our infrastructure has been updated, we will then build our application artifacts (Node.js). For this, we will use [**Webpack**](https://webpack.js.org/). This tool will help us bundle our dependencies and prepare a deployment application.

- Now we have our application ready to be deployed, but we need one last step. As we know, AWS Lambda requires a very specific structure with specific configuration, such as choosing the version and language of our application, a function handler, and application layers. We will use the [**Serverless Framework**](https://www.serverless.com/) to help us build an artifact for deployment. Serverless Framework will zip our application, and through our file called **serverless.yml**, we will specify the configuration we previously mentioned that is needed to have a successful deployment in AWS Lambda.

- As a final step, we have two options. We can prepare a script to deploy our zip using either Serverless Framework or the **AWS CLI**. Alternatively, since we have our Terraform script pointing to Lambda, it is possible to detect changes in the binaries of our zip and deploy the zip with the help of Terraform. For this challenge, we will use the second option since it requires less configuration, though it is not recommended.

- Once our process is complete, a final user will be able to request and reach our microservice with the proper security credentials.

## Generate Token

As explained in the previous resource map, we need to configure our security layer or client credentials to obtain a JWT. This JWT or token will help us reach our microservice, and for that, we will use the following client credentials.

| Parameter        | Value                                                                                  | 
|:-----------------|:---------------------------------------------------------------------------------------|
| Access Token URL | https://fraternitas-unique-domain.auth.us-east-1.amazoncognito.com/oauth2/token        | 
| Client ID        | 2rmhioq1bq375ude3jbedcfh66                                                             |  
| Client Secret    | 6vdnpf87m9bmn1cchajri2ckgnlljqqe17e0t1cthgt86c0g16n                                    |
| Scope            | fraternitas/sec                                                                        |

If you are using an API platform like **Postman**, you can use the following example. Choose the option for **Authorization** and select **OAuth 2.0** to generate an access token.

![Postman Example](/lambda_nozip/media/imgs/postman.png)

This generates an access token and will set it in your header automatically to start calling our microservice.

![Postman Example 2](/lambda_nozip/media/imgs/postman2.png)

## Need help?

Please send an email to alexandropeq@gmail.com.
