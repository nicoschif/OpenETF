# Device Security & Usage Policy

**Version:** 1.0  
**Owner:** CEO  
**Review:** Annual or as needed

## 1. Purpose

This policy defines how devices used to access FastCatalog systems must be configured and used.  
It applies a simple set of rules appropriate for our size and the type of data we handle.

## 2. Scope

This policy applies to:

- All company-managed devices used for:
  - Software development
  - Deployment and system administration
  - Business administration
  - Day-to-day operations and customer support
- Any device used to access:
  - Azure, Supabase, Vercel, MongoDB Atlas, GitHub
  - Internal admin tooling
- Contractor / reviewer devices **when accessing the reviewer portal**

## 3. Device Types

We distinguish the following device categories:

1. **Company-managed Linux devices (Development & Operations)**  
   - Used for code, container builds, and system administration  
   - Example: Debian-based desktops

2. **Company-managed Windows devices (Business & Operations)**  
   - Used for email, documents, finance, and operational dashboards  
   - Windows 11 with disk encryption enabled (e.g., BitLocker)

3. **Contractor / Reviewer Devices**  
   - Used only to access the reviewer portal over HTTPS  
   - No access to backend systems, Supabase, or Azure admin consoles

## 4. General Requirements (All Devices in Scope)

All devices used to access FastCatalog systems must:

1. Be protected with a strong login password or passphrase  
2. Enable automatic operating system security updates where possible  
3. Lock the screen when unattended  
4. Not be shared with unauthorized individuals  
5. Be used primarily for business-related activities when accessing FastCatalog systems

If a device that has access to FastCatalog systems is lost, stolen, or compromised, the CEO must be informed as soon as possible so that access tokens and credentials can be revoked.

## 5. Company-Managed Linux Devices (Development & Operations)

Linux devices used for development and system administration must:

1. Run a supported, security-patched distribution (e.g., Debian-based)  
2. Apply security updates regularly (e.g., via `apt-get` or unattended upgrades)  
3. Store sensitive configuration (e.g., API keys, DB passwords) only in:
   - Local environment files excluded from version control (e.g., `secrets/keys.env`), or
   - Secure password storage (e.g., M365 account vault or equivalent)
4. Never commit secrets, tokens, or `.env` files into Git repositories  
5. Avoid installing unnecessary or high-risk software (P2P, untrusted tools, etc.)

Backend systems (Azure, Supabase, Vercel, MongoDB Atlas) should only be administered from company-managed devices.

## 6. Company-Managed Windows Devices (Business & Operations)

Windows devices used for business and operations must:

1. Have full-disk encryption enabled (e.g., BitLocker)  
2. Have Windows Defender or equivalent anti-malware enabled  
3. Keep Windows security updates enabled and regularly applied  
4. Be used for:
   - Email and communications
   - Documents and finance
   - Operational dashboards and customer support
5. Not be used to store raw database exports or large volumes of operational logs unless explicitly needed and approved

These devices may access admin dashboards (e.g., Supabase, Vercel, Azure portals) but must follow the same MFA and account security practices as Linux devices.

## 7. Contractor / Reviewer Devices

Contractor and reviewer devices:

1. May only access the **reviewer portal** over HTTPS using individual accounts provided by FastCatalog  
2. Must keep login credentials and any access tokens strictly confidential  
3. Must not copy catalog data outside the system except where explicitly authorized for the task  
4. Must not attempt to access backend systems, databases, or infrastructure consoles  
5. Must notify FastCatalog if they suspect their account has been compromised

Misuse of access (e.g., sharing accounts, scraping data, or attempting unauthorized access) may result in immediate account revocation and potential legal action.

## 8. Software Installation and Usage

On company-managed devices:

1. Only software needed for development, operations, or business tasks should be installed  
2. High-risk software (e.g., torrent clients, untrusted downloaders, cracking tools) is not permitted  
3. Browser extensions should be limited to trusted, necessary tools

Contractor devices are not managed by FastCatalog, but contractors must refrain from using the reviewer portal on devices that are clearly insecure, shared broadly, or used for high-risk activities.

## 9. Access to Sensitive Systems

The following systems must only be accessed from company-managed devices:

- Azure Portal / Azure Container Registry / Azure App Service / Azure Database for PostgreSQL  
- Supabase dashboard  
- Vercel dashboard  
- MongoDB Atlas  
- GitHub repositories for FastCatalog

Reviewer devices must **not** be used to administer these systems.

## 10. Enforcement

The CEO is responsible for enforcing this policy.  
If a device or user behavior is found to violate this policy, corrective actions may include:

- Revoking access to systems  
- Rotating credentials/secrets  
- Updating this policy and related configurations  
- In the case of contractors, terminating access and, where appropriate, legal follow-up

## 11. Review

This policy is reviewed at least annually, or when:

- New device types are introduced  
- Access patterns change (e.g., new contractors, new admin tools)  
- Security requirements from customers or providers evolve
