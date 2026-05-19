# x0lie

Portfolio site [x0lie.com](https://x0lie.com) provisioned with Terraform - static files on S3, served via Cloudflare

## Architecture

Cloudflare proxies traffic to an S3 bucket configured for static website hosting, handling TLS at the edge. The bucket restricts access to Cloudflare's published IP ranges, preventing direct access. Terraform state is stored remotely in a separate S3 bucket with file locking, following production-standard practices.

Cloudflare operates in Flexible SSL mode - visitor traffic is encrypted end-to-end to Cloudflare's edge, but the connection from Cloudflare to S3 is HTTP. The intended architecture uses CloudFront with ACM for full encryption and AWS-native CDN, pending account verification with AWS.

## Repository Structure

- `terraform/bootstrap/` - provisions the S3 state bucket, run once manually
- `terraform/infra/` - provisions the site bucket, Cloudflare DNS records and SSL settings
- `site/` - static site files synced to S3 on deploy

## CI/CD

GitHub Actions runs on push to main - applies any Terraform changes and syncs site files to S3. Pull requests trigger a plan-only run for review before merging.
