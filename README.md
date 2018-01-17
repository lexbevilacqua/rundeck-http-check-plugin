# Rundeck HTTP check plugin

This plugin enable a simple node step that perform:

 - External URL request;
 - Analise status code returned;
 - Log body request content;
 - Process return in for distinct groups
    - Ok - (Exit the job with success code)
    - ERROR - (Exit the job with error code)
    - INFO - (Log content informantion e wait for a new verification)

I hope this will be usefull for jobs who demand confirmation for third part applications.

## Parameters

 - URL (String)
    URL to be checked
 - Status code list OK
    - Status code list (comma separated) considered success
 - Status code list ERROR
        description: Status code list (comma separated) considered error
    - type: String
        name: RANGE_INFO
        title: Status code list INFO
        description: Status code list (comma separated) to log information
    - type: String
        name: MAX_TRY
        title: Max attempts
        description: Max requets until error
    - type: String
        name: SECONDS_WAIT
        title: Seconds wait
        description: Seconds between checks
        default: 30
    - type: String
        name: MAX_REQUEST_ERRO
        title: Max requets with error
        description: Max requets with error (undefined status code)
        default: 5

## Build

    make

produces:

    rundeck-http-check-plugin.zip

## Install

Install the plugin in your `$RDECK_BASE/libext` directory:

    mv rundeck-http-check-plugin.zip $RDECK_BASE/libext
