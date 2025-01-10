# sterling-external-authentication-container

I wrote here some code to deploy Sterling External Authentication mainly in Red Hat OpenShit

Documentation to review if necessary https://www.ibm.com/docs/en/external-auth-server/6.1.0?topic=installing-pre-installation-tasks

Install the prerequirements software
- Helm
- MS VSCode
- OC and kubectl command line tool
- Podman to pull and push the images

oc login --token=sha256~8UjI6yxwmES49d4sdfsfsfsfsfsfspNfF51AM --server=https://c100-e.us-south.containers.cloud.ibm.com:31901
Logged into "https://c100-e.us-sfsdfsfds.containers.cloud.ibm.com:31901" as "IAM#sdfsfsfsf.com" using the token provided.

oc new-project seas

helm repo update

helm pull ibm-helm/ibm-seas

tar -xvf ibm-seas-1.5.1.tgz

cd ibm-seas/ibm_cloud_pak/pak_extensions/pre-install/clusterAdministration

./createSecurityClusterPrereqs.sh

cd ibm-seas/ibm_cloud_pak/pak_extensions/pre-install/namespaceAdministration

./createSecurityNamespacePrereqs.sh seas

cd ibm-seas/ibm_cloud_pak/pak_extensions/pre-install/secret

oc create -f ibm-seas-secret.yaml

export ENTITLED_REGISTRY=cp.icr.io
export ENTITLED_REGISTRY_USER=cp
export ENTITLED_REGISTRY_KEY=<entitlement_key>

podman login "$ENTITLED_REGISTRY" -u "$ENTITLED_REGISTRY_USER" -p "$ENTITLED_REGISTRY_KEY"

export SEAS_IMAGE=$(grep -w "repository:" ibm-seas/values.yaml |cut -d '"' -f 2):$(grep -w "tag:" ibm-seas/values.yaml | cut -d '"' -f 2)
    
podman pull $SEAS_IMAGE

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

podman login -u $(oc whoami -t) -p $(oc whoami -t) --tls-verify=false $HOST

podman tag cp.icr.io/cp/ibm-seas/seas-docker-image:6.1.0.2.01 $HOST/seas/seas:6.1.0.2.01

podman push $HOST/seas/seas:6.1.0.2.01

cd ibm-sea

cp values.yaml override.yaml

vi override.yaml

helm install seas -f override.yaml  --debug .

