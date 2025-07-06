# Дипломная работа профессии "DevOps инженер"

Автор: Базанов Валерий

Группа: SHDEVOPS-11


## 1. Создаем сервисный аккаунт, бакет для хранения tfstate файла и registry для хранения образов.

[Директория с terraform скриптами](./src/prepare_account/)

Переходим в директорию /src/prepare_account и выполняем следующие команды:

```
terraform init
terraform apply
```

В результаты выполнения terraform скрипта создаются сервисный аккаунт, бакет для хранения tfstate файла, registry для хранения образов и файл конфигураций в директории проекта "src/tmp/credentials".

terraform output:
```
bucket_name = "terraform-backend-vbazanov-final"
registry_id = "crp0b37t567tu9eml326"
sa_access_key = <sensitive>
sa_secret_key = <sensitive>
service_account_id = "ajedibtch1dcrb462697"
```

<image src="img/service_account.png" alt="Сервисный аккаунт">

<image src="img/bucket.png" alt="Bucket">

<image src="img/registry.png" alt="Registry">


## 2. Создаем веб-приложение и загружаем образ в container registry

Создан репозиторий на GitHub с html-страницей и dockerfile с сборкой nginx-приложения которое будет отдавать статичную html-страницу: https://github.com/ValeriiBazanov/netology-final-app


### 2.1 Создаем iam-токен

Создаем iam токен и сохраняем его в директорию tmp для последующего использования в секрете. Запускаем команду в директории /src.

```
yc iam key create --service-account-id ${service_account_id} --output tmp/registry_sa_key.json
```

Подставляем service-account-id, созданного в пункте 1 ("ajedibtch1dcrb462697").

```
yc iam key create --service-account-id ajedibtch1dcrb462697 --output tmp/registry_sa_key.json
```

<image src="img/iam.png" alt="IAM token creation">


### 2.2 Публикуем образ в yanex container registry

Собираем образ и пушим в container registry.

```
yc container registry configure-docker
docker build -t cr.yandex/${registry_id}/netology-final-app:release-1.0 .
docker push cr.yandex/${registry_id}/netology-final-app:release-1.0
```

Подставляем registry_id container registry созданного в пункте 1 ("crp0b37t567tu9eml326")

```
yc container registry configure-docker
docker build -t cr.yandex/crp0b37t567tu9eml326/netology-final-app:release-1.0 .
docker push cr.yandex/crp0b37t567tu9eml326/netology-final-app:release-1.0
```

<image src="img/build_and_push.png" alt="Build and push container">

<image src="img/container_registry.png" alt="Container registry">


### 2.3 Дорабатываем манифест развертывания приложения в kubernates

Необходимо указать в манифесте deployment приложения [netology-final-app](./src/manifests/web-deployment.yaml) registry id, который был создан в пункте 1 ("crp0b37t567tu9eml326"), в блоке spec/template/spec/containers/image.

```
cr.yandex/${registry_id}/netology-final-app:release-1.0
```

Подставляем значение.

```
cr.yandex/crp0b37t567tu9eml326/netology-final-app:release-1.0
```

<image src="img/app_deployment.png" alt="Deployment netology-final-app">


## 3. Создаем ноды кластера kubernates

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

[Вывод лога](./log/create_infra.log)

В результаты выполнения terraform скрипта создаются сеть, четыре подсети, nat инстанс, виртуальные машины для мастер и рабочих нод, сетевой балансировщик нагрузки и машина администратора. Сформирован файл "src/tmp/host.yml", который будет использоваться ansible для создания кластера kubernates.

<image src="img/network.png" alt="Сеть">

<image src="img/subnet.png" alt="Подсети">

<image src="img/vm.png" alt="Виртуальные машины">

<image src="img/balancer.png" alt="Балансировщик нагрузки">

<image src="img/tfstate.png" alt="tfstate файл в bucket">


## 4. Устанавливаем кластер kubernates

[Ansible playbook](./src/playbook/playbook.yml)

Переходим в директорию /src/playbook и запускаем ansible playbook для создания кластера kubernates и установки окружения (ingress-контроллер, компоненты мониторинга).

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../tmp/host.yml playbook.yml --become --flush-cache
```

[Вывод лога](./log/playbook.log)


### 4.1 Устанавливаем окружение для создания кластера kubernates

Запускаются ansible роли:

- [docker_install](./src/playbook/roles/docker_install/tasks/main.yml)
- [k8s_install](./src/playbook/roles/k8s_install/tasks/main.yml)

На master и worker нодах устанавливаются docker, docker-compose, kubeadm, kubelet, kubectl.


### 4.2 Создаем кластер kubernates

Запускается ansible роль:

- [create_cluster](./src/playbook/roles/create_cluster/tasks/main.yml)

На одной из master нод при помощи kubeadm инициируется кластер kubernates, устанавливается calico, генерируются команды подключения workert и master нод и копируется kubectl config для машины администратора.


### 4.3 Подключаем worker-ноды к кластеру

Запускается ansible роль:

- [worker_node_invite](./src/playbook/roles/worker_node_invite/tasks/main.yml)

На worker-нодах выполняется команда подключения к кластеру kubernates.


### 4.4 Подключаем master-ноды к кластеру

Запускается ansible роль:

- [master_node_invite](./src/playbook/roles/master_node_invite/tasks/main.yml)

На master-нодах выполняется команда подключения к кластеру kubernates.


### 4.5 Настраиваем окружение машины администратора

Запускается ansible роль:

- [admin_prepare](./src/playbook/roles/admin_prepare/tasks/main.yml)

На машине администратора устанавливается kubectl и копируется config-файл в директорию "~/.kube". 
Успешный вывод команды запроса нод кластера.

```
kubectl get nodes
```

<image src="img/kubectl.png" alt="kubectl get nodes">


### 4.6 Устанавливаем окружение для кластера kubernates

Запускается ansible роль:

- [kubernater_env](./src/playbook/roles/kubernater_env/tasks/main.yml)

1. На машине администратора запускаются манифест установки ingress-контроллера. [ingress-controller.yaml](./src/manifests/ingress-controller.yaml).
2. Клонируется репозиторий kube-prometeus и заменяются /kube-prometeus/manifests/[grafana-config.yaml](./src/manifests/grafana-config.yaml) и /kube-prometeus/manifests/[grafana-networkPolicy.yaml](./src/manifests/grafana-networkPolicy.yaml).
3. Выполняется установка kube-prometeus, обновление [deployment-grafana](./src/manifests/grafana-deployment-path.yaml) и настройка [ingress-grafana](./src/manifests/ingress-grafana.yaml).
4. Выполняется установка приложения, опубликованного в yandex container registry в пункте 2. Создается namespase web, secret yandex-registry-secret и выполняется манифест [netology-final-app](./src/manifests/web-deployment.yaml).


## 5. Подключаемся к web-приложению и grafana

Для возможности подключения по имени bazanovvv.ru к web-приложению и grafana добавил правило в файл "/etc/hosts": \<ip load balancer\> bazanovvv.ru.

<image src="img/hosts.png" alt="hosts">


Web-страница доступна по адресу http://bazanovvv.ru

<image src="img/web.png" alt="web-app">

Grafana доступна по адресу http://bazanovvv.ru/grafana/ 

<image src="img/grafana.png" alt="grafana">


## 6. Настраиваем CI/CD приложения

Используем GitHub Actions.
Ссылка на репозиторий: https://github.com/ValeriiBazanov/netology-final-app
Ссылка на Actions: https://github.com/ValeriiBazanov/netology-final-app/actions


### 6.1 Добавляем секреты

Переходим на вкладку Settings и выбираем в блоке Security пункт Secret and variables/Actions.
Добавляем 2 секрета: 
- REGISTRY_ID - значение registry_id созданного в пункте 1 Yandex container registry ("crp0b37t567tu9eml326") для хранения собираемых образов
- YC_SERVICE_ACCOUNT_KEY - сгенерированный в пункте 2.1 токен для публикации собранных образов в registry.

<image src="img/secret_app.png" alt="Secrets">


### 6.2 Создаем Runner

Так как доступ к kubectl осуществляется с машины администратора настроим Runner на этой машине чтобы обновлять версию приложения в кластере kubernates.
Переходим на вкладку Settings и выбираем в блоке Code and automations пункт Actions/Runners. Нажимаем на кнопку "New self-hosted runner". 

<image src="img/runner_comand_app.png" alt="New self-hosted runner comand">

Команды на появившейся странице выполняем на машине администратора.

<image src="img/admin_runner.png" alt="Run command on admin VM">

Новый runner отображается на странице.

<image src="img/runner_app.png" alt="Runners">


### 6.3 Добавляем пайплайн в репозиторий

https://github.com/ValeriiBazanov/netology-final-app/blob/main/.github/workflows/build.yml


### 6.4 Вносим изменения в репозиторий и публикуем тег


Ссылка на коммит: https://github.com/ValeriiBazanov/netology-final-app/commit/0bffcc7d52e178d6c06329fc0ad1c97d6bd4448f

Выполняем команду добавления тега.

```
git tag -a release-4.0 -m "release version 4.0"
git push origin release-4.0
```

Ссылка на тег: https://github.com/ValeriiBazanov/netology-final-app/tree/release-4.0
Запускается и выполняется сборка: https://github.com/ValeriiBazanov/netology-final-app/actions/runs/16101585870

<image src="img/build_app.png" alt="Build and deploy">

Образ опубликован в registry:

<image src="img/registry_app.png" alt="Image in registry">

Приложение в кластере kubernates обновлено:

<image src="img/new_app.png" alt="App">