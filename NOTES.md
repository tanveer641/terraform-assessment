# AWS Terraform Assessment

## Task 2 — Remote State and Locking

### Local State: Concurrent Apply Problem

When Terraform uses local state, each engineer may have a separate
copy of the state file. If two engineers run terraform apply at the
same time, both may calculate changes from outdated state and attempt
conflicting infrastructure operations. This can cause inconsistent
state, conflicting changes, or state drift.

### S3 Remote State and DynamoDB Locking

The S3 backend stores Terraform state centrally so authorized team
members work with the same state file.

The DynamoDB table provides state locking. When a Terraform operation
acquires the lock, another operation using the same locking
configuration must wait or fail to acquire the lock until it is released.

This reduces the risk of concurrent Terraform operations modifying
the same state simultaneously.

The S3 bucket should have appropriate access controls, encryption,
versioning, and recovery protections. DynamoDB locking does not prevent
manual changes made directly in AWS or operations using unrelated state.

### Backend Bootstrap

The S3 bucket and DynamoDB table must be created before initializing
this backend. Their actual names and the AWS region must be supplied
through the backend configuration or deployment process.

Note: DynamoDB-based locking is deprecated in newer Terraform versions.
Terraform's S3 backend also supports native lockfiles through
use_lockfile = true. DynamoDB locking is retained here to satisfy
the assessment requirements.

## Task 3 — Multi-Account IAM

### Account A
- group1 contains engine and ci for programmatic access.
- group2 contains developer-one and developer-two, configured for console and CLI access.
- roleA has broad AWS administrative permissions, with an explicit deny for IAM actions.
- roleB can assume only roleC in Account B.

### Account B
- roleC trusts the exact roleB ARN from Account A.
- Its S3 permissions are scoped to one configured bucket and its objects.

### Production Credentials
I would avoid long-lived IAM user access keys for engineers and CI
pipelines in production. I would prefer AWS IAM Identity Center or
federated access for engineers, and OIDC or workload identity
federation for CI. These approaches use temporary credentials.

The assessment demonstrates IAM users and keys as requested.
Access keys and generated passwords must be handled securely,
and Terraform state must be protected.

### Trust Policy: Account Root vs. Specific Role
Trusting Account A's root principal delegates trust to that account.
Other principals may be able to assume the role if they have the
required identity-based permissions.

Trusting roleB's exact ARN narrows the intended trust relationship
to that specific role, supporting least privilege.

## Task 4 — Least-Privilege CI Policy

The custom CI policy allows the pipeline to authenticate to ECR and
push Docker images to one specified repository. It permits registering
and describing ECS task definitions and updating one specified ECS
service. It also allows read-only access to one build-artifact S3 bucket.

The policy deliberately excludes:
- ECR repository creation and deletion.
- Deleting ECS services or clusters.
- Creating or modifying IAM users, roles, or policies.
- Writing or deleting build artifacts in S3.
- Access to unrelated ECR repositories, ECS services, and S3 buckets.

ECR authentication requires Resource "*". ECS task-definition
registration also requires Resource "*" because that action does not
support resource-level permissions. The remaining supported resource
permissions are scoped to specific resources.

Depending on the deployment workflow, iam:PassRole may be required
for the specific ECS task execution role and task role. If needed,
it should be restricted to those role ARNs.
