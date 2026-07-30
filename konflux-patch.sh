#! /bin/bash

set -e

export MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-agent-globalhub-5-0@sha256:2bc7d20ff59d06693b4a33ea3099b6fe37ecf38e4e71466c727e7cba2d3bee73
export MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-agent-rhel9@${MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-manager-globalhub-5-0@sha256:e6689b0e3e8e10de2c7407f07a3cd38bd902bb324a52d10a8d7cf2c6ec9e59c8
export MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-manager-rhel9@${MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-operator-globalhub-5-0@sha256:ac9fa6a8448bfb0660e61f0591caf3d9874d8b73c505bf249b6a56cddc742e03
export MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-rhel9-operator@${MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/glo-grafana-globalhub-5-0@sha256:faf9d40d87f60550cef65cfc930b607ba4bb505b3f66e9a38166a0dfc709acc3
export MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-grafana-rhel9@${MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/postgres-exporter-globalhub-5-0@sha256:c5b3d1b9831ae1eec1e1d274d3ad60e092c1a3d4920e6c96a10462a3aa92d823
export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-postgres-exporter-rhel9@${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE=registry.redhat.io/rhel9/postgresql-16@sha256:4b2c10b97c7247e3dbb570eb3e345ff43e03e4d83894a280c9c19983e70f84b8

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
   -e "s|quay.io/stolostron/grafana-global-hub:12.4.0|${MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE}|g" \
   -e "s|quay.io/prometheuscommunity/postgres-exporter:v0.15.0|${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE}|g" \
   -e "s|quay.io/stolostron/postgresql-16:9.5-1732622748|${MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE}|g" \
	"${csv_file}"

sed -i -e "s|multicluster-global-hub-operator\\.v|multicluster-global-hub-operator-rh\\.v|g" "${csv_file}"
sed -i -e "s|5.0.0-dev|5.0.0|g" "${csv_file}"
sed -i -e "s|multicluster-global-hub-operator|multicluster-global-hub-operator-rh|g" "metadata/annotations.yaml"
