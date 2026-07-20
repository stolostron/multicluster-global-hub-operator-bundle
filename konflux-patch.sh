#! /bin/bash

set -e

export MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-agent-globalhub-1-5@sha256:d72c2cb957352baea85025687c47b70733aa67194727f90e9b7859b483b95ad3
export MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-agent-rhel9@${MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-manager-globalhub-1-5@sha256:c78306857c0b37eff7ed13f20087dd13649459653f696219fa8fc9defbd32ead
export MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-manager-rhel9@${MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-operator-globalhub-1-5@sha256:993fbd886cc12782fb261ec83bcd46d2b5ef31fffd5ea0665d756ff780380aba
export MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-rhel9-operator@${MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/glo-grafana-globalhub-1-5@sha256:eb566cdcbde63711b4907ea3f1b091209086c43922233a5c00a112e8a576da94
export MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-grafana-rhel9@${MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/postgres-exporter-globalhub-1-5@sha256:94dd3d14dd9322ae33e18b3d6f049da76a7a8e5dadd5e0f190558e85700ec78c
export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-postgres-exporter-rhel9@${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE=registry.redhat.io/rhel9/postgresql-16@sha256:97183f972000688a0d36d6651eb08b5961d767599e132eac11577e1d94e1cb2d

export MULTICLUSTER_GLOBAL_HUB_KESSEL_INVENTORY_API_STAGE_IMAGE=quay.io/redhat-services-prod/project-kessel-tenant/kessel-inventory/inventory-api@sha256:c443e7494d7b1dd4bb24234cf265a3f0fb5e9c3c0e2edeb2f00285a2286ff24f

export MULTICLUSTER_GLOBAL_HUB_KESSEL_SPICEDB_OPERATOR_STAGE_IMAGE=quay.io/redhat-services-prod/project-kessel-tenant/kessel-relations/spicedb-operator@sha256:4c27d1b073a0e44e02f03526fcafc24b7a224a492a88553e11a8bfc23646c513

export MULTICLUSTER_GLOBAL_HUB_KESSEL_SPICEDB_STAGE_IMAGE=quay.io/redhat-services-prod/project-kessel-tenant/kessel-relations/spicedb@sha256:c9b50dbc28d9a0db2fd2001eb6e9ebfbca5bfcc35d5537bfc1a25601c5648a29

export MULTICLUSTER_GLOBAL_HUB_KESSEL_RELATIONS_API_STAGE_IMAGE=quay.io/redhat-services-prod/project-kessel-tenant/kessel-relations/relations-api@sha256:fff1d072580a65ee78a82a845eb256a669f67a0b0c1b810811c2a66e6c73b10d

csv_name="multicluster-global-hub-operator.clusterserviceversion.yaml"
csv_file="manifests/${csv_name}"
if [ ! -f $csv_file ]; then
   echo "CSV file not found, the version or name might have changed on us!"
   exit 5
fi

# Append relatedImages to the CSV
echo -e "  relatedImages:\n" \
     " - name: multicluster-global-hub-manager\n" \
     "   image: ${MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE}\n" \
     " - name: multicluster-global-hub-agent\n" \
     "   image: ${MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE}\n" \
     " - name: grafana\n" \
     "   image: ${MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE}\n" \
     " - name: postgres-exporter\n" \
     "   image: ${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE}\n" \
     " - name: postgresql\n" \
     "   image: ${MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE}\n" \
   >> "${csv_file}"

sed -i \
   -e "s|quay.io/stolostron/multicluster-global-hub-operator:latest|${MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE}|g" \
   -e "s|quay.io/stolostron/multicluster-global-hub-manager:latest|${MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE}|g" \
   -e "s|quay.io/stolostron/multicluster-global-hub-agent:latest|${MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE}|g" \
   -e "s|quay.io/stolostron/grafana:2.12.0-SNAPSHOT-2024-09-03-21-11-25|${MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE}|g" \
   -e "s|quay.io/prometheuscommunity/postgres-exporter:v0.15.0|${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE}|g" \
   -e "s|quay.io/stolostron/postgresql-16:9.5-1732622748|${MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE}|g" \
	"${csv_file}"

sed -i -e "s|multicluster-global-hub-operator\\.v|multicluster-global-hub-operator-rh\\.v|g" "${csv_file}"
sed -i -e "s|multicluster-global-hub-operator|multicluster-global-hub-operator-rh|g" "metadata/annotations.yaml"
