# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»- Михалёв Сергей

### Подготовка к выполнению задания
Так как я фактически нахожусь в недружественной Европе, то сталкиваюсь с проблемой ограничения на использование платных ресурсов Yandex Cloud. Таким образом могу выполнить только второе задание с исполоьзованием ресурса Anazon AWS.

---

### Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

**Решение**

1. Следуя структуре проекта из предыдущего задания создал новый модуль [*storage*](modules/storage/). В нём описал процесс создания S3 bucket.
Здесь для обеспечения доступа к ресурсу извне пришлось создать [*aws_s3_bucket_public_access_block*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) и [*aws_s3_bucket_policy*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy).</br>
Identy and Access Manager (IAM) AWS требует выдачи соответсвующего разрешения для пользовтаеля, от имени которого я поднимаю ресурсы:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutBucketAcl",
        "s3:GetBucketAcl"
      ],
      "Resource": "arn:aws:s3:::hw-smmikh-january-2025-store-bucket"
    }
  ]
}
```
Изображение [*cafe.jpg*](images/cafe.jpg) поместил в нутрь S3 через [*aws_s3_object*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object). В итоге оно было доступно по ссылке *"https://hw-smmikh-january-2025-store-bucket.s3.amazonaws.com/cafe.jpg"*.</br>
<img src="images/Task_1_3.png" alt="Task_1_3" width="700" height="auto"></br> Ссылку я получил из [*outputs*](modules/storage/outputs.tf):</br>
<img src="images/Task_1_1.png" alt="Task_1_1" width="700" height="auto"></br>
Хранилище *hw-smmikh-january-2025-store-bucket* появилось в списке:</br>
<img src="images/Task_1_2.png" alt="Task_1_2" width="700" height="auto"></br>

2. Сделал [*Launch configurations*](modules/instances/main.tf) с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. здесь я воспользовался *user_data*. Создал отдельный файл с шаблоном [*cloud-config*](modules/instances/user_data.yaml.tpl), куда передал переменную s3_image_url со ссылкой на S3:
```
user_data = templatefile("${path.module}/user_data.yaml.tpl", {
    s3_image_url = var.s3_image_url
  })
```

3. Написал [*aws_launch_configuration*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) создания одинаковых инстансов через [*Autoscaling Group*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) и [*load balanser*](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb). для Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Ссылку на публичный ip *Autoscaling Group* я так же вывел в [outputs](modules/storage/outputs.tf):</br>
<img src="images/Task_1_1.png" alt="Task_1_1" width="700" height="auto"></br>

Скриншот обращения в браузере по DNS имени балансировщика нагрузки:</br>
<img src="images/Task_3_1.png" alt="Task_3_1" width="500" height="auto"></br>
Список запущенных виртуальных машие, видно использование двух зон:</br>
<img src="images/Task_3_2.png" alt="Task_3_2" width="700" height="auto"></br>
*Load Balanse*r:</br>
<img src="images/Task_3_3.png" alt="Task_3_3" width="700" height="auto"></br>
*Target Group* со списком инстансов и *Health Check* (все инстансы здоровы):</br>
<img src="images/Task_3_3.png" alt="Task_3_3" width="700" height="auto"></br>

