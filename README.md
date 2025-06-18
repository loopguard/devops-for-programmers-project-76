# DevOps for Programmers Project 76

### Hexlet tests and linter status:
[![Actions Status](https://github.com/loopguard/devops-for-programmers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/loopguard/devops-for-programmers-project-76/actions)

## Описание

Ansible проект для автоматического деплоя Redmine на два сервера приложений с отдельным сервером базы данных в Yandex Cloud. Включает мониторинг через DataDog.

## Быстрый старт

```bash
# 1. Клонируйте репозиторий
git clone <your-repo-url>
cd devops-for-programmers-project-76

# 2. Настройте переменные
make init
# Отредактируйте .env файл

# 3. Создайте зашифрованные секреты
make vault-create
# Добавьте секреты в редакторе

# 4. Задеплойте приложение
make deploy

# 5. Установите мониторинг DataDog
make datadog
```

## Структура проекта

```
.
├── playbook.yml              # Настройка серверов (Docker, pip)
├── deploy.yml                # Деплой Redmine
├── inventory.template.ini    # Шаблон инвентаризации
├── group_vars/webservers/    # Переменные для серверов
├── templates/                # Шаблоны файлов
├── Makefile                  # Команды автоматизации
└── SETUP.md                  # Подробные инструкции
```

## Архитектура

```
┌─────────────────┐
│   Load Balancer │
└─────────┬───────┘
          │
    ┌─────┴─────┐
    │           │
┌───▼───┐   ┌───▼───┐
│App 1  │   │App 2  │
│Server │   │Server │
│:3000  │   │:3000  │
└───┬───┘   └───┬───┘
    │           │
    └─────┬─────┘
          │
    ┌─────▼─────┐
    │   DB      │
    │  Server   │
    │  :5432    │
    └───────────┘
```

## Команды

- `make init` - создание .env файла
- `make vault-create` - создание зашифрованного vault
- `make vault-edit` - редактирование секретов
- `make setup` - подготовка серверов
- `make deploy` - деплой приложения
- `make datadog` - установка DataDog агента

## Безопасность

- ✅ Все секреты зашифрованы в Ansible Vault
- ✅ IP адреса и пароли не попадают в репозиторий
- ✅ Поддержка GitHub Secrets для автоматического деплоя
- ✅ Переменные окружения для локальной разработки

## Ссылка на приложение

После деплоя: [https://nevermore.space/](https://nevermore.space/)
