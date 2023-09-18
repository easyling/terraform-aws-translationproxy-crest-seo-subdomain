variable "locale" {
  description = "Two-by-two locale code"
  type        = string
}

variable "domain" {
  description = "FQDN for serving the translations"
  type        = string
}

variable "project" {
  description = "The project ID provided by the LSP"
  type        = string
}

variable "app_domain" {
  description = "App domain provided by LSP"
  type        = string
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version spec for CloudFront to accept."
  default     = "TLSv1.1_2016"
}

variable "caching_min_ttl" {
  type = number
  description = "Minimum TTL for CloudFront cache in seconds"
  default = 1
}

variable "caching_default_ttl" {
  type = number
  description = "Default TTL for CloudFront cache in seconds, in the absence of other directives"
  default = 300
}

variable "caching_max_ttl" {
  type = number
  description = "Maximum TTL for CloudFront cache in seconds"
  default = 86400
}
