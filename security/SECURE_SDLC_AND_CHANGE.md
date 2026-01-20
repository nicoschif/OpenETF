# Secure Development & Change Management

**Version:** 1.0  
**Owner:** CEO  
**Review:** Annual or as needed

## 1. Purpose

This document defines how FastCatalog.ai designs, changes, and deploys software to production in a secure and controlled way, appropriate for a lean, cloud-native SaaS.

It sets expectations for how changes are made, reviewed, deployed, and monitored so that our practices match what we tell customers and partners.

## 2. Scope

This standard applies to all production-facing code and configuration that can affect customers or the catalog, including:

- Backend services and APIs running in cloud environments  
- Frontend applications served to users  
- Supabase edge functions and database routines  
- Any scheduled jobs, workers, or internal tools that interact with production data or services

It does **not** describe step-by-step deployment commands or full architecture diagrams; those live in scripts, READMEs, and other technical documentation.

## 3. Roles & Responsibilities

- **CEO (Change Owner)**  
  - Owns the SDLC and change management process  
  - Approves and performs production deployments  
  - Ensures changes follow this standard

- **Future engineers or contributors (if any)**  
  - Must follow this document for any change that affects production  
  - Must use individual accounts (no shared accounts)  
  - Must not make unplanned changes directly in production consoles

## 4. General Principles

All production-facing code and configuration must follow these principles:

1. **Version control**  
   - Code and configuration are kept in private Git repositories under the FastCatalog-ai organization.  
   - Changes are made in branches and merged to the main/production branch via commits and pull requests (PRs). Self-review by the CEO is acceptable for now.

2. **Traceability**  
   - Every production change (backend, frontend, edge function, DB change, job) must be traceable to a Git commit or documented change note.

3. **No ad-hoc production edits**  
   - Direct, undocumented edits in production consoles (e.g., toggling settings or editing functions by hand) should be avoided.  
   - If an emergency requires a console change, it must be documented afterward (e.g., commit, internal note, or script update).

4. **Secrets management**  
   - Secrets (API keys, DB passwords, tokens) are not committed to Git.  
   - They are provided via environment variables or env files excluded from version control (see DEVICE_POLICY and local secrets practices).  
   - If a device or account is suspected compromised, relevant secrets are rotated.

5. **Least privilege**  
   - Only the CEO (or explicitly authorized maintainers) have permissions to deploy to production or change core cloud configurations.

## 5. Change Lifecycle

All changes that affect production should follow this lifecycle:

1. **Plan**  
   - Identify the change (feature, bugfix, configuration adjustment).  
   - Consider potential impact on customers and catalog integrity.

2. **Implement**  
   - Make the change in a Git branch.  
   - Update tests or basic checks if needed.

3. **Review**  
   - Review the change (self-review by CEO for now; PR review if others contribute).  
   - Confirm that no secrets are committed and the change is consistent with policies.

4. **Deploy**  
   - Deploy using defined mechanisms (deployment scripts, CI/CD, Vercel integration, Supabase migration/edge deployment commands, etc.).  
   - Avoid manual “one-off” changes in production consoles.

5. **Monitor**  
   - After deployment, check logs and basic functionality for errors or anomalies.  
   - Roll back or hotfix if necessary, then document what was done.

Normal changes follow this full cycle; urgent fixes may move faster but must still be committed, deployed in a traceable way, and reviewed after the fact.

## 6. Deployment Expectations

For all production components (backend, frontend, Supabase code, jobs):

- Deployments must use a **repeatable mechanism** (script, CI, provider integration) rather than ad-hoc manual edits.  
- Configuration changes that materially affect behavior should be:
  - Stored in configuration files or environment variables, and  
  - Controlled by the same change process as code where practical.

If a deployment fails or causes issues:

- Fix or revert the change in Git.  
- Redeploy using the normal mechanism.  
- Capture any lessons learned for future changes.

## 7. Vulnerability Management in the SDLC

FastCatalog.ai integrates vulnerability management into its development and change process as follows:

- Production images and environments are refreshed regularly (at least monthly, or sooner if needed) to pick up OS and dependency updates.  
- Dependencies are managed via requirements files and updated as part of scheduled rebuilds.  
- GitHub Dependabot or equivalent security alerts are enabled for relevant repositories and reviewed periodically; important issues are addressed in upcoming releases based on severity and impact.  
- Security advisories from key providers (cloud platforms, auth providers, source control) are monitored as time allows.

If a serious vulnerability is identified in a component we use, we plan and deploy a targeted update/rebuild as soon as practical.

## 8. Logging & Post-Deployment Checks

After significant changes or deployments:

- Logs in the relevant providers (e.g., cloud runtime logs, frontend logs, auth logs) should be checked for unusual errors.  
- Authentication failure digests and other alerts should be reviewed to spot abnormal patterns.  
- If a problem is detected, the change may be rolled back or corrected quickly, then reviewed.

## 9. Documentation & Review

- This SDLC and change management standard lives in the engineering-handbook repository.  
- It applies to all production-facing repositories and services at FastCatalog.ai.  
- The CEO reviews this document at least annually or when:
  - There are major changes in architecture or deployment approaches, or  
  - Customer or regulatory requirements change.

Engineers should use this document as a reference when planning and making changes that affect production.
