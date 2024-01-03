#!/usr/bin/env bash

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -n "${DEBUG:-}" ]] && set -x


if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script, optional GIT_BASEURL and GIT_REPO to formed the git url GIT_BASEURL/GIT_ORG/*"; exit 1; fi

set -u

GIT_BRANCH=${GIT_BRANCH:-master}
GIT_BASEURL=${GIT_BASEURL:-https://github.com}
GIT_GITOPS=${GIT_GITOPS:-multi-tenancy-gitops.git}
GIT_GITOPS_BRANCH=${GIT_GITOPS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_INFRA=${GIT_GITOPS_INFRA:-multi-tenancy-gitops-infra.git}
GIT_GITOPS_INFRA_BRANCH=${GIT_GITOPS_INFRA_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_SERVICES=${GIT_GITOPS_SERVICES:-multi-tenancy-gitops-services.git}
GIT_GITOPS_SERVICES_BRANCH=${GIT_GITOPS_SERVICES_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_APPLICATIONS=${GIT_GITOPS_APPLICATIONS:-multi-tenancy-gitops-apps.git}
GIT_GITOPS_APPLICATIONS_BRANCH=${GIT_GITOPS_APPLICATIONS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_NAMESPACE=${GIT_GITOPS_NAMESPACE:-openshift-gitops}
HELM_REPOURL=${HELM_REPOURL:-https://charts.cloudnativetoolkit.dev}



echo "Setting kustomization patches to ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS} on branch ${GIT_GITOPS_BRANCH}"
echo "Setting kustomization patches to ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA} on branch ${GIT_GITOPS_INFRA_BRANCH}"
echo "Setting kustomization patches to ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES} on branch ${GIT_GITOPS_SERVICES_BRANCH}"
echo "Setting kustomization patches to ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS} on branch ${GIT_GITOPS_APPLICATIONS_BRANCH}"

echo "Replacing in 0-bootstrap"
find ${SCRIPTDIR}/../0-bootstrap -name '*.yaml' -print0 |
  while IFS= read -r -d '' File; do
    if grep -q "kind: Application\|kind: AppProject" "$File"; then
      echo "$File"
      #### for first time
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_BRANCH}#${GIT_GITOPS_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_INFRA}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_INFRA_BRANCH}#${GIT_GITOPS_INFRA_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_SERVICES}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_SERVICES_BRANCH}#${GIT_GITOPS_SERVICES_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_APPLICATIONS}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_APPLICATIONS_BRANCH}#${GIT_GITOPS_APPLICATIONS_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_NAMESPACE}#${GIT_GITOPS_NAMESPACE}#" $File
      # sed -i'.bak' -e "s#\${HELM_REPOURL}#${HELM_REPOURL}#" $File

      #### for case which files already replaced
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}#" $File
      sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-infra.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_INFRA_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-services.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_SERVICES_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-apps.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_APPLICATIONS_BRANCH}#" $File
      sed -i'.bak' -e "s#\openshift-gitops#${GIT_GITOPS_NAMESPACE}#" $File
      sed -i'.bak' -e "s#\${HELM_REPOURL}#${HELM_REPOURL}#" $File

      rm "${File}.bak"
    fi
  done

echo "Replacing in multi-tenancy-gitops-apps"
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTDIR/../..
find multi-tenancy-gitops-apps -name '*.yaml' -print0 |
  while IFS= read -r -d '' File; do
    if grep -q "kind: Application\|kind: AppProject" "$File"; then
      echo "$File"
      #### for first time
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_BRANCH}#${GIT_GITOPS_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_INFRA}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_INFRA_BRANCH}#${GIT_GITOPS_INFRA_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_SERVICES}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_SERVICES_BRANCH}#${GIT_GITOPS_SERVICES_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_APPLICATIONS}#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_APPLICATIONS_BRANCH}#${GIT_GITOPS_APPLICATIONS_BRANCH}#" $File
      # sed -i'.bak' -e "s#\${GIT_GITOPS_NAMESPACE}#${GIT_GITOPS_NAMESPACE}#" $File
      # sed -i'.bak' -e "s#\${HELM_REPOURL}#${HELM_REPOURL}#" $File

      #### for case which files already replaced
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}#" $File
      sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-infra.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_INFRA_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-services.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_SERVICES_BRANCH}#" $File
      sed -i'.bak' -e "s#https://github.com/seatechit/multi-tenancy-gitops-apps.git#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}#" $File
      # sed -i'.bak' -e "s#seatech-cp4i#${GIT_GITOPS_APPLICATIONS_BRANCH}#" $File
      sed -i'.bak' -e "s#\openshift-gitops#${GIT_GITOPS_NAMESPACE}#" $File
      sed -i'.bak' -e "s#\${HELM_REPOURL}#${HELM_REPOURL}#" $File

      rm "${File}.bak"
    fi
  done

echo "done replacing variables in kustomization.yaml files"
echo "git commit and push changes now"
