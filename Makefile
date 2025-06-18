.PHONY: setup install-deps deploy init vault-edit vault-view vault-create generate-inventory prepare-ssh-key

# Инициализация проекта
init:
	@if [ ! -f .env ]; then \
		cp env.example .env; \
		echo "✅ Файл .env создан из env.example"; \
		echo "📝 Отредактируйте .env файл с вашими данными"; \
	else \
		echo "✅ Файл .env уже существует"; \
	fi

# Генерация inventory.ini из шаблона
generate-inventory:
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		envsubst < inventory.template.ini > inventory.ini; \
		echo "✅ Файл inventory.ini сгенерирован из шаблона"; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Создание зашифрованного файла vault
vault-create:
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		ansible-vault create group_vars/webservers/vault.yml; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Редактирование зашифрованного файла vault
vault-edit:
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		ansible-vault edit group_vars/webservers/vault.yml; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Просмотр зашифрованного файла vault
vault-view:
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		ansible-vault view group_vars/webservers/vault.yml; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Установка зависимостей Ansible Galaxy
install-deps:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

# Подготовка серверов (установка pip и docker)
setup: generate-inventory install-deps
	ansible-playbook -i inventory.ini playbook.yml

# Деплой приложения Redmine
deploy: generate-inventory install-deps
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		ansible-playbook -i inventory.ini deploy.yml --ask-vault-pass; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Установка DataDog агента
datadog: generate-inventory install-deps
	@if [ -f .env ]; then \
		export $$(grep -v '^#' .env | xargs) && \
		ansible-playbook -i inventory.ini datadog.yml --ask-vault-pass; \
	else \
		echo "❌ Ошибка: файл .env не найден. Выполните 'make init'"; \
		exit 1; \
	fi

# Подготовка приватного SSH ключа для Ansible
prepare-ssh-key:
	@if [ -n "$$ANSIBLE_SSH_PRIVATE_KEY" ]; then \
		echo "$$ANSIBLE_SSH_PRIVATE_KEY" | tr -d '\r' > /tmp/ansible_ssh_key; \
		chmod 600 /tmp/ansible_ssh_key; \
		echo "ANSIBLE_SSH_KEY_PATH=/tmp/ansible_ssh_key" >> .env; \
		echo "✅ SSH ключ подготовлен"; \
	else \
		echo "❌ Переменная ANSIBLE_SSH_PRIVATE_KEY не задана"; \
		exit 1; \
	fi 