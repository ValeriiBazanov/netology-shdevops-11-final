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

В результаты выполнения terraform скрипта создаются сервисный аккаунт, бакет для хранения tfstate файла и файл конфигураций в директории проекта "src/tmp/credentials".

<image src="img/service_account.png" alt="Сервисный аккаунт">

<image src="img/bucket.png" alt="Bucket">


### 2. Создаем ноды кластера kubernates

В скрипте /src/create_infrastructure/providers.tf устанавлены следующие значения для параметров из блока terraform/backend:
- shared_credentials_files - ссылка на credential файл сгенерированный в пункте 1. Текущее значение "../tmp/credentials".
- profile - значение переменной profile_name указанное при выполнении скрипта /src/prepare_account. Текущее значение "finalwork".
- bucket - значение переменной bucket_name указанное при выполнении скрипта /src/prepare_account. Текущее значение "terraform-backend-vbazanov-final".

[Директория с terraform скриптами](./src/create_infrastructure/)

Переходим в директорию /src/create_infrastructure и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создаются сеть, четыре подсети, nat инстанс, виртуальные машины для мастер и рабочих нод, сетевой балансировщик нагрузки и машина администратора. Сформирован файл "src/tmp/host.yml", который будет использоваться ansible для создания кластера kubernates.

<image src="img/tbd" alt="Сеть">

<image src="img/tbd" alt="Подсети">

<image src="img/tbd" alt="Виртуальные машины">

<image src="img/tbd" alt="Балансировщик нагрузки">


### 3. Устанавливаем кластер kubernates

[Ansible playbook](./src/install_k8s/playbook.yml)

Переходим в директорию /src/install_k8s и запускаем ansible playbook для создания кластера kubernates.

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../tmp/host.yml playbook.yml --become --flush-cache
```

В результате работы ansible playbook на созданных ранее нодах разворачивается кластер kubernates. 
Доступ к kubectl настроен на машине администратора. Конфиг-файл скопирован в директорию "~/.kube/".

<image src="img/tbd" alt="kubectl get nodes">
