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

variable "forward_query_strings" {
  description = "Forward query strings to Easyling. CAUTION: may decrease effectiveness of caching, and lead to greater traffic numbers."
  default     = false
  type        = bool
}

variable "app_domain" {
  description = "App domain provided by LSP"
  type        = string
}

variable "acm_cert_arn" {
  description = "ARN of the dynamic certificate provisioned by AWS. Can be left empty, in which case HTTPS will not work!"
  default     = ""
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version spec for CloudFront to accept."
  default     = "TLSv1.1_2016"
}
