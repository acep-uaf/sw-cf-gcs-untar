gcloud functions deploy sw-cf-gcs-untar \
  --gen2 \
  --runtime=python311 \
  --region=us-west1 \
  --service-account=untar-ingest@acep-ext-eielson-2021.iam.gserviceaccount.com \
  --source=src \
  --entry-point=gcs_event_to_pubsub \
  --trigger-event-filters="type=google.cloud.storage.object.v1.finalized" \
  --trigger-event-filters="bucket=sw-eielson-tar-archive" \
  --memory 16384MB \
  --timeout 540s  \
  --set-env-vars PROJECT_ID=acep-ext-eielson-2021,TOPIC_NAME=sw-df-untar,FILE_EXTENSION=.tar.gz 
