# K8s Application Helm Chart

This Helm chart deploys a multi-tier application with Tomcat, MySQL, Memcached, and RabbitMQ.

## Installation

```bash
# Install the chart
helm install my-app ./helm-chart

# Install with custom values
helm install my-app ./helm-chart -f custom-values.yaml

# Upgrade the deployment
helm upgrade my-app ./helm-chart
```

## Configuration

### Updating Image Versions

To update image versions, modify the `values.yaml` file:

```yaml
tomcat:
  image:
    tag: tomcat-v2  # Update to new version

mysql:
  image:
    tag: mysql-v2   # Update to new version
```

Or use `--set` flag:

```bash
helm upgrade my-app ./helm-chart --set tomcat.image.tag=tomcat-v2
```

### Key Configuration Options

- **Enable/Disable Services**: Set `enabled: false` for any service you don't need
- **Resource Limits**: Adjust CPU and memory limits in the resources section
- **Persistence**: Configure storage size and class for MySQL
- **Ingress**: Update host and annotations for your environment

## Services

- **Tomcat**: Web application server (port 8080)
- **MySQL**: Database server (port 3306) with persistent storage
- **Memcached**: Caching server (port 11211)
- **RabbitMQ**: Message broker (port 5672)

## Dependencies

Tomcat service includes init containers that wait for MySQL, Memcached, and RabbitMQ to be ready before starting.