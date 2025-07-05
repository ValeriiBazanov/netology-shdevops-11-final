# Дипломная работа профессии "DevOps инженер"

Автор: Базанов Валерий

Группа: SHDEVOPS-11


## 1. Создаем сервисный аккаунт и бакет для хранения tfstate файла

[Директория с terraform скриптами](./src/prepare_account/)

Переходим в директорию /src/prepare_account и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создаются сервисный аккаунт, бакет для хранения tfstate файла и файл конфигураций в директории проекта "src/tmp/credentials".

<image src="img/service_account.png" alt="Сервисный аккаунт">

<image src="img/bucket.png" alt="Bucket">

<image src="img/registry.png" alt="Registry">


## 2. Создаем ноды кластера kubernates

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


## 3. Устанавливаем кластер kubernates

[Ansible playbook](./src/playbook/playbook.yml)

Переходим в директорию /src/playbook и запускаем ansible playbook для создания кластера kubernates и установки окружения (ingress-контроллер, компоненты мониторинга).

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../tmp/host.yml playbook.yml --become --flush-cache
```


### 3.1 Установка окружения для создания кластера kubernates

Запускаются ansible роли:

- [docker_install](./src/playbook/roles/docker_install/tasks/main.yml)
- [k8s_install](./src/playbook/roles/k8s_install/tasks/main.yml)

На master и worker нодах устанавливаются docker, docker-compose, kubeadm, kubelet, kubectl.


### 3.2 Создание кластера kubernates

Запускается ansible роль:

- [create_cluster](./src/playbook/roles/create_cluster/tasks/main.yml)

На одной из master нод при помощи kubeadm инициируется кластер kubernates, устанавливается calico, генерируются команды подключения workert и master нод и копируется kubectl config для машины администратора.


### 3.3 Подключаются worker-ноды к кластеру

Запускается ansible роль:

- [worker_node_invite](./src/playbook/roles/worker_node_invite/tasks/main.yml)

На worker-нодах выполняется команда подключения к кластеру kubernates.


### 3.4 Подключаются master-ноды к кластеру

Запускается ansible роль:

- [master_node_invite](./src/playbook/roles/master_node_invite/tasks/main.yml)

На master-нодах выполняется команда подключения к кластеру kubernates.


### 3.5 Настройка окружения машины администратора

Запускается ansible роль:

- [admin_prepare](./src/playbook/roles/admin_prepare/tasks/main.yml)

На машине администратора устанавливается kubectl и копируется config-файл в директорию "~/.kube". 
Успешный вывод команды запроса нод кластера.

```
kubectl get nodes
```

<image src="img/tbd" alt="kubectl get nodes">


### 3.6 Установка окружения для кластера kubernates

Запускается ansible роль:

- [kubernater_env](./src/playbook/roles/kubernater_env/tasks/main.yml)

1. На машине администратора запускаются манифест установки ingress-контроллера. [ingress-controller.yaml](./src/manifests/ingress-controller.yaml).
2. Клонируется репозиторий kube-prometeus и заменяются /kube-prometeus/manifests/[grafana-config.yaml](./src/manifests/grafana-config.yaml) и /kube-prometeus/manifests/[grafana-networkPolicy.yaml](./src/manifests/grafana-networkPolicy.yaml).
3. Выполняется установка kube-prometeus, обновление [deployment-grafana](./src/manifests/grafana-deployment-path.yaml) и настройка [ingress-grafana](./src/manifests/ingress-grafana.yaml).

```
kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests
kubectl patch deployment -n monitoring grafana --patch-file grafana-deployment-path.yaml
kubectl apply -f ingress-grafana.yaml
```

Grafana доступна по адресу http://bazanovvv.ru/grafana/ . Для возможности подключения по имени bazanovvv.ru добавил правило в файл "/etc/hosts": \<ip load balancer\> bazanovvv.ru.

<image src="img/tbd" alt="grafana">
