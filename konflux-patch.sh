#! /bin/bash

set -e

export MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-agent-globalhub-1-6@sha256:83f0a20f6697e95b75a5ffb9065132db7b79d8037810f6e734481e022df8748c
export MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-agent-rhel9@${MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-manager-globalhub-1-6@sha256:611cac66698f014a36d841158a0e7cf257a296c9453affe989efa3602720372f
export MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-manager-rhel9@${MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-operator-globalhub-1-6@sha256:e528b7e2a9701d1d4966b1f7e96efbf435f3a4ccc56d81dbe7b85cc8ab7eb3ef
export MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-rhel9-operator@${MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/glo-grafana-globalhub-1-6@sha256:f82de757aa825a67b30a6d10583880e1c7f06193c8f0852fd84255e5d49d2862
export MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-grafana-rhel9@${MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/postgres-exporter-globalhub-1-6@sha256:5651fea9a755cdafc17db0e88b9df3e2e10678cd1c051447b6938c247405b18a
export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-postgres-exporter-rhel9@${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE=registry.redhat.io/rhel9/postgresql-16@sha256:35700ba9386e8070c91afdac200f72a18f0cd69d64b7ac914b55452afe511ceb

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
sed -i -e "s|1.6.0-dev|1.6.0|g" "${csv_file}"
sed -i -e "s|multicluster-global-hub-operator|multicluster-global-hub-operator-rh|g" "metadata/annotations.yaml"
