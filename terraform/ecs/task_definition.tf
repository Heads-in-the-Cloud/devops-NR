resource "aws_ecs_task_definition" "task_definition" {
  family = "utopia"
  container_definitions = jsonencode([
    {
      "essential" : true,
      "name" : "auth",
      "image" : data.aws_ssm_parameter.image_auth.value,
      "environment" : [
        {
          "name" : "UTOPIA_DB_HOST",
          "value" : local.db_creds.host
        },
        {
          "name" : "UTOPIA_DB_PORT",
          "value" : "${tostring(local.db_creds.port)}"
        },
        {
          "name" : "UTOPIA_DB_USER",
          "value" : local.db_creds.username
        },
        {
          "name" : "UTOPIA_DB_PASSWORD",
          "value" : local.db_creds.password
        },
        {
          "name" : "UTOPIA_DB_NAME",
          "value" : "utopia"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_AUTH_PORT",
          "value" : "8084"
        }
      ],
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 8084,
          "hostPort" : 8084
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/fargate/service/utopia",
          "awslogs-region" : "us-west-2",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    },
    {
      "essential" : true,
      "name" : "flight",
      "image" : data.aws_ssm_parameter.image_flight.value,
      "environment" : [
        {
          "name" : "UTOPIA_DB_HOST",
          "value" : local.db_creds.host
        },
        {
          "name" : "UTOPIA_DB_PORT",
          "value" : "${tostring(local.db_creds.port)}"
        },
        {
          "name" : "UTOPIA_DB_USER",
          "value" : local.db_creds.username
        },
        {
          "name" : "UTOPIA_DB_PASSWORD",
          "value" : local.db_creds.password
        },
        {
          "name" : "UTOPIA_DB_NAME",
          "value" : "utopia"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_FLIGHTS_PORT",
          "value" : "8081"
        }
      ],
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 8081,
          "hostPort" : 8081
        }
      ]
    },
    {
      "essential" : true,
      "name" : "booking",
      "image" : data.aws_ssm_parameter.image_booking.value,
      "environment" : [
        {
          "name" : "UTOPIA_DB_HOST",
          "value" : local.db_creds.host
        },
        {
          "name" : "UTOPIA_DB_PORT",
          "value" : "${tostring(local.db_creds.port)}"
        },
        {
          "name" : "UTOPIA_DB_USER",
          "value" : local.db_creds.username
        },
        {
          "name" : "UTOPIA_DB_PASSWORD",
          "value" : local.db_creds.password
        },
        {
          "name" : "UTOPIA_DB_NAME",
          "value" : "utopia"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_BOOKINGS_PORT",
          "value" : "8082"
        }
      ],
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 8082,
          "hostPort" : 8082
        }
      ]
    },
    {
      "essential" : true,
      "name" : "user",
      "image" : data.aws_ssm_parameter.image_user.value,
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 8083,
          "hostPort" : 8083
        }
      ],
      "environment" : [
        {
          "name" : "UTOPIA_DB_HOST",
          "value" : local.db_creds.host
        },
        {
          "name" : "UTOPIA_DB_PORT",
          "value" : "${tostring(local.db_creds.port)}"
        },
        {
          "name" : "UTOPIA_DB_USER",
          "value" : local.db_creds.username
        },
        {
          "name" : "UTOPIA_DB_PASSWORD",
          "value" : local.db_creds.password
        },
        {
          "name" : "UTOPIA_DB_NAME",
          "value" : "utopia"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_USERS_PORT",
          "value" : "8083"
        }
      ]
    },
    {
      "essential" : true,
      "name" : "orchestrator",
      "image" : data.aws_ssm_parameter.image_orchestrator.value,
      "environment" : [
        {
          "name" : "UTOPIA_MICROSERVICE_BOOKINGS_PORT",
          "value" : "8082"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_FLIGHTS_PORT",
          "value" : "8081"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_USERS_PORT",
          "value" : "8083"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_AUTH_PORT",
          "value" : "8084"
        },
        {
          "name" : "UTOPIA_MICROSERVICE_ORCHESTRATOR_PORT",
          "value" : "8080"
        }
      ],
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 8080,
          "hostPort" : 8080
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/fargate/service/utopia",
          "awslogs-region" : "us-west-2",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_agent.arn
  depends_on = [
    aws_iam_role_policy_attachment.ecsTaskExecutionRole_policy
  ]
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.secrets.secret_string
  )
}
