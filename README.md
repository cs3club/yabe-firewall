# yabe-firewall

Ansible configuration for the Yabe range firewall team.

## Devices

| Hostname       | IP           | Role                        |
|----------------|--------------|-----------------------------|
| vyos           | 10.30.1.1    | Border router, NAT          |
| debian-router  | 10.30.1.2    | Distribution router, ntopng |
| mikrotik       | 10.30.1.3    | Linux segment firewall      |
| pfsense        | 10.30.1.4    | Windows segment firewall    |

## Setup

    # Install required collections (includes ansible.netcommon, ansible.posix, community.routeros)
    ansible-galaxy collection install -r requirements.yml

    # Copy secrets template and fill in real values
    cp vars/secrets.yml.example vars/secrets.yml
    nano vars/secrets.yml

    # Dry run first — always
    ansible-playbook site.yml --check --diff

    # Apply
    ansible-playbook site.yml

    # Apply a single role only
    ansible-playbook site.yml --tags mikrotik
    ansible-playbook site.yml --tags mikrotik-lockdown

## Structure

    inventory/hosts.yml        <- target machines and connection settings
    roles/                     <- one subdirectory per role
      mikrotik/                <- read-only: verifies baseline firewall rules are present
      mikrotik_lockdown/       <- restricts SSH to admin host, disables unused services
    exports/                   <- manual config exports from each device
      mikrotik/                <- RouterOS baseline export (.rsc)
    vars/main.yml              <- non-secret variables (committed)
    vars/secrets.yml           <- secrets (never committed, gitignored)
    vars/secrets.yml.example   <- secrets template (committed, CHANGEME values only)
    site.yml                   <- master playbook entry point
    ansible.cfg                <- ansible settings

## Security Notes

- SSH access to MikroTik is restricted to the admin host (10.30.10.22) only
- Winbox is fully disabled — management is via SSH and Ansible only
- All unused services disabled: telnet, ftp, www, www-ssl, api, api-ssl
- Secrets never committed to git — see vars/secrets.yml.example for required variables

## Reference

- Planning document: yabe-range-planning-document.md
- Ansible docs: https://docs.ansible.com
- community.routeros docs: https://docs.ansible.com/ansible/latest/collections/community/routeros/
