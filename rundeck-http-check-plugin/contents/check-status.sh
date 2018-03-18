#!/bin/bash

export URL_CHECK=${1}

export RANGE_OK=${2}
export RANGE_ERROR=${3}
export RANGE_INFO=${4}

export MAX_TRY=${5}

export SECONDS_WAIT=${6}
export MAX_REQUEST_ERRO=${7}

contains() {
    [[ $1 =~ (^|[,])$2($|[,]) ]] && return 0  || return 1
}

if [ -z ${URL_CHECK} ] || [ -z ${RANGE_OK} ] || [ -z ${RANGE_ERROR} ] || [ -z ${RANGE_INFO} ]
then
    echo "[ERRO] Required fields: URL, Status code list OK, Status code list ERROR and Status code list INFO"
    exit 1
fi

if [ -z ${MAX_REQUEST_ERRO} ]
then
    MAX_REQUEST_ERRO=5
    echo "[INFO] MAX_REQUEST_ERRO set to default: 5"
fi

if [ -z ${SECONDS_WAIT} ]
then
    SECONDS_WAIT=30
    echo "[INFO] SECONDS_WAIT set to default: 30"
fi

TENTATIVA=0
TENTATIVA_ERRO=0

echo "[INFO] Check URL: ${URL_CHECK}"
echo "[INFO] RANGE_OK: ${RANGE_OK}"
echo "[INFO] RANGE_ERROR: ${RANGE_ERROR}"
echo "[INFO] RANGE_INFO: ${RANGE_INFO}"

while true
do
    (( TENTATIVA++ ))
	RET_CODE=`curl --insecure -I ${URL_CHECK} 2>/dev/null | head -n 1 | cut -d$' ' -f2`
    CONTENT=`curl --insecure -s ${URL_CHECK}`
    
    echo "[INFO] Attempt (${TENTATIVA}) - Status code: ${RET_CODE}"
    
    if contains ${RANGE_ERROR} ${RET_CODE}
    then
        echo "[ERROR] Error confirmed (${RET_CODE}) in ${URL_CHECK}"
        echo $CONTENT
        exit 1
    elif contains ${RANGE_OK} ${RET_CODE}
    then
        echo "[INFO] Success confirmed (${RET_CODE}) in ${URL_CHECK}"
        echo $CONTENT
        exit 0
    elif contains ${RANGE_INFO} ${RET_CODE}
    then
        echo "[INFO] Info status (${RET_CODE}) in ${URL_CHECK}"
        echo $CONTENT
    else
        (( TENTATIVA_ERRO++ ))
        if [ ${TENTATIVA_ERRO} -ge ${MAX_REQUEST_ERRO} ]
        then
            echo "[ERROR] Maximum number of error attempts exceeded: ${MAX_REQUEST_ERRO}" 
            exit 1
        fi
        echo "[WARN] Error attempt: ${TENTATIVA_ERRO} - maximum: ${MAX_REQUEST_ERRO}" 
    fi

    if [ ! -z ${MAX_TRY} ] && [ ${MAX_TRY} -lt ${TENTATIVA} ]
    then
        echo "[ERROR] Maximum number of attempts exceeded: ${MAX_TRY}"
        exit 1
    else
        echo "[INFO] Waiting ${SECONDS_WAIT} seconds for the next attempt"
        sleep $SECONDS_WAIT
    fi
done

