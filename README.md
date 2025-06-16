# Дипломная работа профессии "DevOps инженер"

Автор: Базанов Валерий

Группа: SHDEVOPS-11


## Создание облачной инфраструктуры

### 1. Создаем сервисный аккаунт и бакет для хранения tfstate файла

[Директория с terraform скриптами](./src/prepare_account/)

Переходим в директорию /src/prepare_account и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создаются сервисный аккаунт, бакет для хранения tfstate файла и файл конфигураций в корневой директории проекта ".aws/credentials".

<image src="img/service_account.png" alt="Сервисный аккаунт">

<image src="img/bucket.png" alt="Bucket">


### 2. Настраиваем окружение в terraform скриптах инфраструктуры

В скрипте /src/init_infrastructure/providers.tf устанавливаем следующие значения для параметров из блока terraform/backend:
- shared_credentials_files - ссылка на credential файл сгенерированный в пункте 1. Текущее значение "../../.aws/credentials".
- profile - значение переменной profile_name указанное при выполнении скрипта /src/prepare_account. Текущее значение "finalwork".
- bucket - значение переменной bucket_name указанное при выполнении скрипта /src/prepare_account. Текущее значение "terraform-backend-vbazanov-final".

### 3. Создаем ноды кластера kubernates

[Директория с terraform скриптами](./src/init_infrastructure/)

Переходим в директорию /src/init_infrastructure и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создаются сеть, три подсети и виртуальные машины для мастер и рабочих нод.

<image src="img/tbd" alt="Сеть">

<image src="img/tbd" alt="Подсети">

<image src="img/tbd" alt="Виртуальные машины">