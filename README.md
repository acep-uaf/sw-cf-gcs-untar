# SW-CF-GCS-UNTAR Cloud Function

The `sw-cf-gcs-untar` is a Cloud Function written in Python, designed to respond to change events in a Google Cloud Storage (GCS) bucket and publish a message to a Pub/Sub topic. The code checks if the changed file has a `.tar.gz` extension and processes it accordingly.

## Cloud Function
 
### Description

The gen 2 Cloud Function `sw-cf-gcs-untar` is written in Python. Upon triggering by a change to a Google Cloud Storage bucket, the function checks whether the changed file ends with the `.tar.gz` extension. If the file meets this criterion, the function processes it; if not, the file is ignored.

During processing, the function fetches the file name from the event payload and constructs a message with the bucket's name and the file name. This message is then published to a Pub/Sub topic (`TOPIC_NAME` as specified in the environment variables). The message payload (not attributes) contains details of the `.tar.gz` file that led to the message's publication, enabling the subscriber(s) of the Pub/Sub topic to identify the bucket and the `.tar.gz` file in question.

Thus, the `sw-cf-gcs-untar` function monitors a specific Cloud Storage bucket and sends signals via Pub/Sub whenever a .tar.gz file is added or modified. It acts as a bridge, linking the GCS bucket changes to the Pub/Sub topic. This can then trigger subsequent operations based on these changes.

 ### Deployment
 
 Deployment is now streamlined with environment variables. Before deploying, ensure you've configured the `eiedeploy.env` file with the appropriate values.

Deploy the Cloud Function with the provided shell script:
 
 ```bash
 ./eiedeploy.sh
 ```

 This script wraps the following `gcloud` command:
 
 ```bash
 #!/bin/bash

  # Source the .env file
  source eiedeploy.env

  # Deploy the function
  gcloud functions deploy sw-cf-gcs-untar \
    --$GEN2 \
    --runtime=$RUNTIME \
    --region=$REGION \
    --service-account=$SERVICE_ACCOUNT \
    --source=$SOURCE \
    --entry-point=$ENTRY_POINT \
    --trigger-event-filters=$TRIGGER_EVENT_FILTER1 \
    --trigger-event-filters=$TRIGGER_EVENT_FILTER2 \
    --memory=$MEMORY \
    --timeout=$TIMEOUT \
    --set-env-vars PROJECT_ID=$PROJECT_ID,TOPIC_NAME=$TOPIC_NAME,FILE_EXTENSION=$FILE_EXTENSION
 ```

 ### .env File Configuration

 You should have an `eiedeploy.env` file with the following variables defined:

 ```
 GEN2=<value>
 RUNTIME=<value>
 REGION=<value>
 SERVICE_ACCOUNT=<value>
 SOURCE=<value>
 ENTRY_POINT=<value>
 TRIGGER_EVENT_FILTER1=<value>
 TRIGGER_EVENT_FILTER2=<value>
 MEMORY=<value>
 TIMEOUT=<value>
 PROJECT_ID=<value>
 TOPIC_NAME=<value>
 FILE_EXTENSION=<value>
```
Replace `<value>` with the appropriate values for your deployment.

### Environment Variable Descriptions

Below are descriptions for each environment variable used in the deployment script:

- **GEN2**=`<value>`:
  - Description: Specifies the generation of the Cloud Function to deploy. Google Cloud Functions has multiple generations and this denotes which one you intend to use.
  
- **RUNTIME**=`<value>`:
  - Description: Specifies the runtime environment in which the Cloud Function executes. For example: `python311` for Python 3.11.
  
- **REGION**=`<value>`:
  - Description: The Google Cloud region where the Cloud Function will be deployed and run. Example values are `us-west1`, `europe-west1`, etc.
  
- **SERVICE_ACCOUNT**=`<value>`:
  - Description: The service account under which the Cloud Function will run. This defines the permissions that the Cloud Function has during execution.
  
- **SOURCE**=`<value>`:
  - Description: Path to the source code of the Cloud Function. Typically, this points to a directory containing all the necessary files for the function.
  
- **ENTRY_POINT**=`<value>`:
  - Description: Specifies the name of the function or method within the source code to be executed when the Cloud Function is triggered.
  
- **TRIGGER_EVENT_FILTER1**=`<value>`:
  - Description: A filter to specify the type of event that triggers the Cloud Function. For instance, it could denote a specific type of change in a GCS bucket.
  
- **TRIGGER_EVENT_FILTER2**=`<value>`:
  - Description: An additional filter to narrow down the events that trigger the Cloud Function. This could be another condition related to changes in a GCS bucket.
  
- **MEMORY**=`<value>`:
  - Description: The amount of memory to allocate for the Cloud Function. This is denoted in megabytes, e.g., `16384MB`.
  
- **TIMEOUT**=`<value>`:
  - Description: The maximum duration the Cloud Function is allowed to run before it is terminated. Expressed in seconds, e.g., `540s`.
  
- **PROJECT_ID**=`<value>`:
  - Description: The Google Cloud project ID under which the Cloud Function is deployed.
  
- **TOPIC_NAME**=`<value>`:
  - Description: The name of the Pub/Sub topic to which the Cloud Function publishes messages.
  
- **FILE_EXTENSION**=`<value>`:
  - Description: The file extension that the Cloud Function checks for in the GCS bucket. For this function, it's typically set to `.tar.gz`.

Ensure to set each `<value>` in the `eiedeploy.env` file appropriately before deploying the Cloud Function. **Note:** For security reasons, do not cheeck the `eiedeploy.env` with set values into a public repository such as github.



### Dependencies
 
 The Cloud Function's dependencies are listed in the `requirements.txt` file and include the `google-cloud-pubsub` and `google-cloud-storage` packages.


