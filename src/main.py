from google.cloud import pubsub_v1
import os
import json

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(os.getenv('PROJECT_ID'), os.getenv('TOPIC_NAME'))

def gcs_event_to_pubsub(data, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
        data (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """

    # Print event type and timestamp
    print(f"Event type: {context.event_type}")
    print(f"Event timestamp: {context.timestamp}")

    file_name = data['name']

    if file_name.endswith(os.getenv('FILE_EXTENSION')):
        print(f"Processing file: {file_name}")

        message = {
            "bucket": data["bucket"],
            "name": file_name
        }
        message_data = json.dumps(message).encode('utf-8')

        try:
            # Publish message to Pub/Sub
            publish_message = publisher.publish(topic_path, message_data)
            # Get the result of the publish.
            publish_message.result()
        except Exception as e:
            print(f'An error occurred when trying to publish message: {str(e)}')
            raise
        else:
            print(f"Published message for {file_name} in bucket {data['bucket']}")
    else:
        print(f"Ignored file: {file_name} (not a {os.getenv('FILE_EXTENSION')} file)")