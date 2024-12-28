# utils_setup

## content

- script for instaling docker, kind, kubectl, helm
- minimal cluster config for up kube cluster with kind 

## Usage

### Instaling

```bash
git clone https://gitlab.com/eatmore01/utils_setup.git
cd utils_setup
chmod +x "$(pwd)/install.sh" && "$(pwd)/install.sh"
```

### itteraction with cluster with help kind cli

#### deploy cluster

```bash
kind create cluster --config kind.yml
```

#### delete cluster

```bash
kind delete cluster --name minimal-cluster
```