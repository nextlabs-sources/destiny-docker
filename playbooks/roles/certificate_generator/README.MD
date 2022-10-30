# dbinit

Role for handling certificate-generator related configuration

## Notes

This role is meant to setup certificate-generator in a java container. A entrypoint script will be put at /usr/local/bin/entrypoint. Pass `cert` as first argument to the script to run the certificate-generator script. Environment variables required are:

* SSL_PASSPHRASE (string): The password for keys to be generated and the keystore generated
* CERT_DN (string): OPTIONAL, the DN of the certs, if not specified, default: 'CN=CompliantEnterprise Server, OU=CompliantEnterprise, O=NextLabs, L=San Mateo, ST=CA, C=US'
* KEY_ALGO (string): OPTIONAL, the key's algorithm, default: 'DSA'
* CERT_VALIDITY (number): OPTIONAL, the key's validity (days), default 3650.
* OUTPUT_PATH (string): OPTIONAL, if not specified, will output to /output

The container is a one-shot container to generate required Control Center server's certificates.

## Tunables

* artifacts_path (string): Path to artifacts

## Dependencies

* None

## Example Usage

```bash
docker run --rm -it -e SSL_PASSPHRASE=changeit -e OUTPUT_PATH=/tmp <image_name> cert
```
