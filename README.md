# Utils setup

`Debian based`

### Instaling

```bash
git clone https://github.com/eatmore01/utils-setup.git
cd utils_setup
chmod +x "$(pwd)/install.sh" && "$(pwd)/install.sh"
```

#### Local cluster

```bash
# create
talosctl cluster create --workers 2 --name test
# destroy
talosctl cluster destroy --name test
```