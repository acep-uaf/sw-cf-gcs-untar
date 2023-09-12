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
