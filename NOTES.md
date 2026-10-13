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
