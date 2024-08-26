# TQG Code Challenge

The solution for the coding challenge.

## System

Information about the system where the Terraform module was developed.

```sh
Terraform v1.9.5
on darwin_arm64
+ provider registry.terraform.io/hashicorp/archive v2.5.0
+ provider registry.terraform.io/hashicorp/aws v5.64.0

Running on a MacOS Pro with Apple M2 Max
```

## Setup Step

- [ ] [Install Terraform](https://developer.hashicorp.com/terraform/install)
- [ ] [AWS CLI Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
  - [ ] This module assumes it is created under `$HOME/.aws/credentials`
  - [ ] Change if you want to use profiles or a different location [here](./providers.tf#L17)
- [ ] Create a new bucket for the state management. I named it [`tqg-terraform-state-bucket`](./providers.tf#L3)
- [ ] `terraform init`
- [ ] `tf import 'aws_s3_bucket.state_bucket["tqg-terraform-state-bucket"]' tqg-terraform-state-bucket`
  - [ ] Rename `tqg-terraform-state-bucket` if you are using a different bucket. This imports the state bucket
- [ ] `terraform apply`

## Architecture

![Architecture](./architecture.excalidraw.svg)

## Todos

Unfortunately, I haven't tested by using a file change.
I used ChatGPT to support me here.