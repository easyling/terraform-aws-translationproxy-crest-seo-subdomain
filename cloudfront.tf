resource "aws_cloudfront_distribution" "translations_at_root" {
  enabled = true
  aliases = [
    var.domain
  ]

  comment = "translationproxy_${var.project}_${var.locale}"

  tags = {
    product = "translationproxy",
    project = var.project,
  }

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn = aws_lambda_function.prerender_headers.qualified_arn
      include_body = true
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.prerender_redirect.qualified_arn
      include_body = true
    }

    target_origin_id       = "translationproxy-${var.locale}"
    viewer_protocol_policy = "allow-all"

    cache_policy_id = aws_cloudfront_cache_policy.caching_with_queries.id
  }

  origin {
    domain_name = lower("${var.locale}-${var.project}-j.${var.app_domain}")
    origin_id   = "translationproxy-${var.locale}"

    custom_header {
      name  = "X-TranslationProxy-Cache-Info"
      value = "disable"
    }
    custom_header {
      name  = "X-TranslationProxy-EnableDeepRoot"
      value = "false"
    }
    custom_header {
      name  = "X-TranslationProxy-AllowRobots"
      value = "true"
    }
    custom_header {
      name  = "X-TranslationProxy-ServingDomain"
      value = var.domain
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_read_timeout    = 60
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.dynamic_cert.arn
    minimum_protocol_version = var.min_tls_version
    ssl_support_method       = "sni-only"
  }
}

output "domains_for_subdomain_publishing" {
  value = [
    aws_cloudfront_distribution.translations_at_root.domain_name
  ]
}
