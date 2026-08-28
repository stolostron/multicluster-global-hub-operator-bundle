#! /bin/bash

set -e

export MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-agent-globalhub-5-2@sha256:bc94481984c419f6bc0cf50c8bd504a2a449a9ceabc70c546f8629f374ad6b7f
export MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-agent-rhel9@${MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-manager-globalhub-5-2@sha256:c1ea71b6034a6b8a563c6ff6797671bf223a66d0c0b567f1edd50eed18e11e9c
export MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-manager-rhel9@${MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-operator-globalhub-5-2@sha256:9ba7903743539c77f88a9abf959adb8c076cb1ee97deee1ffa2a5bb3bbbdac46
export MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-rhel9-operator@${MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/glo-grafana-globalhub-5-2@sha256:1e3762c23b3f35feac816a9305345f5dce591c8037e15de1b4ab890cdcc26bd3
export MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-grafana-rhel9@${MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/postgres-exporter-globalhub-5-2@sha256:c95f0a4b12ca41c8bf14931475cef2b35293ac2a8f08556a8cd9d2108f91b4eb
export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-postgres-exporter-rhel9@${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE=registry.redhat.io/rhel9/postgresql-16@sha256:56fa16102d33d68c1e7f7c59f4fd28533c43f52eca967898d391d80c79ddaa82

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
sed -i -e "s|5.2.0-dev|5.2.0|g" "${csv_file}"
sed -i -e "s|multicluster-global-hub-operator|multicluster-global-hub-operator-rh|g" "metadata/annotations.yaml"
