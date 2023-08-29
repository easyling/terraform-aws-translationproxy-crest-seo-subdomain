data "aws_lambda_function" "set_prerender_header" {
  function_name = "crest-prerender-test-SetPrerenderHeader-TtxzCLiZqbo6"
}

data "aws_lambda_function" "redirect_to_prerender" {
  function_name = "crest-prerender-test-RedirectToPrerender-FBhJ3KhHMR9K"
}
