# AWS helper functions

export AWS_PROFILE="aidev"

aws:login() {
  aws sso login --sso-session lmg-sso
  export AWS_PROFILE="aidev"
  echo "AWS SSO session started and AWS_PROFILE set to aidev."
}

aws:check-sso() {
  if aws sts get-caller-identity --output text --query 'Account' >/dev/null 2>&1; then
    echo "AWS SSO session is active (Profile: $AWS_PROFILE)"
    return 0
  else
    echo "AWS SSO session expired. Run 'aws:login' to authenticate."
    return 1
  fi
}
