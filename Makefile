prepare:
	ansible-galaxy install -r requirements.yml

secret:
	ansible-vault encrypt group_vars/webservers/vault.yml

vault-pass:
	ansible-playbook -i hosts.yml playbook.yml --vault-password-file vault-pass.txt

setup:
	ansible-playbook -i hosts.yml playbook.yml --tags setup

deploy:
	ansible-playbook -i hosts.yml playbook.yml --tags deploy

monitoring:
	ansible-playbook -i hosts.yml playbook.yml --tags monitoring

skip:
	ansible-playbook -i hosts.yml playbook.yml --skip-tags monitoring


