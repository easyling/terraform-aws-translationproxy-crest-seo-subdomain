resource "aws_cloudfront_cache_policy" "caching_with_queries" {
  name = "translationproxy-${var.project}_${var.locale}"

  comment = "Generic cache settings permitting query params"

  min_ttl     = var.caching_min_ttl
  default_ttl = var.caching_default_ttl
  max_ttl     = var.caching_max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Origin",
          "Accept",
          "CloudFront-Forwarded-Proto",
          "Referer",
          "User-Agent",
          "X-TranslationProxy-CrawlingFor",
          "Accept-Language",
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}
