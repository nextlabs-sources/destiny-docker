# list of components in combo
Management Server
Intelligence Server
Policy Management Server
Enrollment Manager
Dynamic Access Control
Administrator
Reporter
Control Center Console



## Environment Variables


* DATABASE_USERNAME (string): Database username
* DATABASE_PASSWORD (string): Database encrypted password
* DATABASE_CONNECTSTRING (string): Database connect string
* ES_CLUSTER_NAME (string): Elasticsearch cluster name, if not specified, will use `elasticsearch`.
* ES_HOST (string): Elasticsearch hostname
* ES_PORT (string): Elasticsearch port, if not specified, will use 9300

## Tunables

* artifacts_path (string): Path to artifacts

## Dependencies

* ansible-xml

## Example Usage

```bash
# For using postgres
docker run -it \
    -e DATABASE_USERNAME=clarion \
    -e 'DATABASE_PASSWORD=123next!' \
    -e DATABASE_CONNECTSTRING=postgresql://pf-linux01.qapf1.qalab01.nextlabs.com:5432/clarion \
    ...
    <image_name>
# For using oracle
docker run -it \
    -e DATABASE_USERNAME=clarion \
    -e 'DATABASE_PASSWORD=123next!' \
    -e DATABASE_CONNECTSTRING=oracle:thin:@ccsgdcora12c.qapf1.qalab01.nextlabs.com:1521:orcl \
    ...
    <image_name>
# For using mssql
docker run -it \
    -e DATABASE_USERNAME=clarion \
    -e 'DATABASE_PASSWORD=123next!' \
    -e DATABASE_CONNECTSTRING=sqlserver://ccsgdcsql2012.qapf1.qalab01.nextlabs.com:1433;DatabaseName=clarion; \
    ...
    <image_name>
```




