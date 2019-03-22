workflow "Shell Pipeline" {
  on = "pull_request"
  resolves = ["shell-fmt"]
}

action "shell-fmt" {
  uses = "docker://mvdan/shfmt:v2.6.3"
  args = "-i 2 -ci -d ."
}

workflow "shaking finger action" {
  on = "pull_request"
  resolves = ["post gif on fail"]
}

action "post gif on fail" {
  uses = "jessfraz/shaking-finger-action@master"
  secrets = ["GITHUB_TOKEN"]
}
