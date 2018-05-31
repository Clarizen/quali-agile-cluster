#!/bin/bash

# export KUBECONFIG=$PWD/server/CSCommon/CloudProvider/k8s.yaml;
if [ "$1" == "proxy" ] ; then
  xdg-open "http://localhost:8001/ui" && kubectl proxy;
elif [ "$1" == "exec" ] ; then
  if [ "$#" == "2" ] ; then
    echo "exec [namespace=$KNAME] [pod=$2]"
    kubectl exec -ti $(kubectl get pods -n $KNAME | awk '/'$2'/ {print $1;exit}') -n $KNAME  -- /bin/bash;
  else
    echo "exec [namespace=$KNAME] [pod=$2] [container=$3]"
    kubectl exec -ti $(kubectl get pods -n $KNAME | awk '/'$2'/ {print $1;exit}') -n $KNAME -c $3 -- /bin/bash;
  fi
elif [ "$1" == "describe" ] ; then
  echo "describe [namespace=$KNAME] [pod=$2]"
  kubectl describe pod $2 -n $KNAME;
elif [ "$1" == "logs" ] ; then
  if [ "$#" == "3" ] ; then
    if [ "$2" == "p" ] ; then
      echo "logs -p [namespace=$KNAME] [pod=$3]"
      kubectl logs -p $(kubectl get pods -n $KNAME | awk '/'$3'/ {print $1;exit}') -n $KNAME;
    elif [ "$2" == "f" ] ; then
      echo "logs -f [namespace=$KNAME] [pod=$3]"
      kubectl logs -f $(kubectl get pods -n $KNAME | awk '/'$3'/ {print $1;exit}') -n $KNAME;
    fi
  elif [ "$#" == "4" ] ; then
    if [ "$2" == "p" ] ; then
      echo "logs -p [namespace=$KNAME] [pod=$3] [container=$4]"
      kubectl logs -p $(kubectl get pods -n $KNAME | awk '/'$2'/ {print $1;exit}') -n $KNAME -c $3;
    elif [ "$2" == "f" ] ; then
      echo "logs -f [namespace=$KNAME] [pod=$3] [container=$4]"
      kubectl logs -f $(kubectl get pods -n $KNAME | awk '/'$2'/ {print $1;exit}') -n $KNAME -c $3;
    fi
  fi
elif [ "$1" == "pods" ] ; then
  echo "pods in [namespace=$KNAME]:"
  kubectl get pods -n $KNAME;
elif [ "$1" == "namespaces" ] ; then
  echo "namespaces:"
  kubectl get namespaces -l colony-sandbox-id
elif [ "$1" == "kill" ] ; then
  if [ "$#" == "2" ] ; then
    echo "kills [namespace=$2]:"
    kubectl delete namespace $2
  else
    echo "kills [namespace=$KNAME]:"
    kubectl delete namespace $KNAME
  fi
elif [ "$1" == "service" ] ; then
  if [ "$2" == "get" ] ; then
    echo "service get [namespace=$KNAME]"
    kubectl get svc -n $KNAME;
  fi
elif [ "$1" == "die" ] ; then
  echo "destroying all namespaces:"
  kubectl delete namespaces -l colony-sandbox-id
fi
