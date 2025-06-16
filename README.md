# Дипломная работа профессии "DevOps инженер"

Автор: Базанов Валерий

Группа: SHDEVOPS-11


## Создание облачной инфраструктуры

1. Создаем сервисный аккаунт и бакет для хранения tfstate файла

[Директория с terraform скриптами](./src/prepare_account/)

Переходим в директорию /src/prepare_account и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создается сервисный аккаунт, бакет для хранения tfstate файла и файл конфигураций в корневой директории проекта ".aws/credentials".

<image src="img/service_account.png" alt="Сервисный аккаунт">

<image src="img/bucket.png" alt="Bucket">
