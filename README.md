# Translation Proxy Terraform Module

This README aims to provide a concise guide on how the provided Terraform module sets up a translation proxy using AWS CloudFront and other related services.

## Overview

The Terraform module essentially establishes an AWS CloudFront distribution tailored to serve localized content. It dynamically reroutes certain requests to `service.prerender.io` for better SEO optimization and intelligently manages caching policies to balance responsiveness with resource utilization.

### Components:

1. **CloudFront Distribution**: Serves the translated content with the help of Lambda@Edge for request and response manipulations.
2. **Lambda@Edge**: Two Lambda functions intercept the viewer and origin requests. These functions:
    - Identify bots to prerender content for SEO optimization.
    - Redirect requests to `service.prerender.io` when needed.
3. **CloudFront Cache Policy**: Determines caching behavior based on headers, cookies, and query strings. Cache policies ensure that the dynamic nature of translated content is handled efficiently without compromising speed.

## Variables Explained

- **`locale`**: Specifies the target language or region using a two-by-two locale code, e.g., "en-US" or "fr-FR".

- **`domain`**: The fully qualified domain name (FQDN) intended for serving the translations. This determines the URL where end users access the localized content.

- **`project`**: The project ID given by the Language Service Provider (LSP). This is essential to link the infrastructure to a specific translation project.

- **`app_domain`**: The domain provided by the LSP which typically hosts the translated content or applications.

- **`min_tls_version`**: The minimum TLS version CloudFront should accept for secure connections. The default is "TLSv1.1_2016", but can be modified based on security requirements.

- **`caching_min_ttl`**, **`caching_default_ttl`**, **`caching_max_ttl`**: These variables manage the Time-To-Live (TTL) settings for CloudFront's caching. They determine how long content stays in the cache before a new version is retrieved.

## Behind the Scenes: How it Works

1. When a user accesses the content using the FQDN specified in `domain`, the request hits the CloudFront distribution.

2. Lambda@Edge functions inspect this request:
    - If the user agent matches certain bot criteria (like Googlebot or Bingbot), the request gets flagged for prerendering.
    - Headers are adjusted for such requests, which include tokens and host information for `service.prerender.io`.

3. For prerender-flagged requests, instead of serving directly from CloudFront, the Lambda function redirects the request to `service.prerender.io`.

4. Responses, either from `service.prerender.io` or directly from the origin specified by `app_domain`, are then served to the user through CloudFront.

5. The CloudFront cache policy ensures that caching behavior considers query strings, headers, and cookies. This is crucial as translated content can be dynamic and may change based on various factors.

## Deployment and Integration

To utilize this Terraform module, integrate it with your main Terraform script and adjust the necessary variables as per your project requirements. Make sure to handle AWS credentials and region settings appropriately in your Terraform environment to ensure seamless deployment.
