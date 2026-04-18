#! /bin/bash

set -e

export MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-agent-globalhub-1-4@sha256:59f2a4e9d5138fc8d55d9e1a2ad06a4dd8fa845decbdd525b442df1681f98e58
export MULTICLUSTER_GLOBAL_HUB_AGENT_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-agent-rhel9@${MULTICLUSTER_GLOBAL_HUB_AGENT_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-manager-globalhub-1-4@sha256:b7dd90144aab2cb8d779f7430f3fbde50a2d75f122b9ae8f49a273873b62c94d
export MULTICLUSTER_GLOBAL_HUB_MANAGER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-manager-rhel9@${MULTICLUSTER_GLOBAL_HUB_MANAGER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/multicluster-global-hub-operator-globalhub-1-4@sha256:7395c1fb438ab6ac6197260bf0ff3e0202ec4ce809c67cf8dc7a44eeebdd60ed
export MULTICLUSTER_GLOBAL_HUB_OPERATOR_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-rhel9-operator@${MULTICLUSTER_GLOBAL_HUB_OPERATOR_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/glo-grafana-globalhub-1-4@sha256:3571f1f5881f74d70f357e933d6f3746019de35052f439820808987025a25c10
export MULTICLUSTER_GLOBAL_HUB_GRAFANA_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-grafana-rhel9@${MULTICLUSTER_GLOBAL_HUB_GRAFANA_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE=quay.io/redhat-user-workloads/acm-multicluster-glo-tenant/postgres-exporter-globalhub-1-4@sha256:9f96c8492fa7b1b821dea1c1e1846a4f35656fa49d7af5d7a6e1de7120382f26
export MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_IMAGE="registry.redhat.io/multicluster-globalhub/multicluster-globalhub-postgres-exporter-rhel9@${MULTICLUSTER_GLOBAL_HUB_POSTGRES_EXPORTER_STAGE_IMAGE##*@}"

export MULTICLUSTER_GLOBAL_HUB_POSTGRESQL_IMAGE=registry.redhat.io/rhel9/postgresql-16@sha256:68a50a3476472a529cedd40b36d59dd85d668bfa9fac1f0b1bef149a16733923

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
