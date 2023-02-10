# Nightscout S3 Proxy!

This is a simple docker container that proxies data from [Nightscout](https://github.com/nightscout/cgm-remote-monitor) to a bucket on S3.

## Why?

You may be self hosting your Nightscout instance, but you may want to use the data in other places outside your network. If you don't have your services exposed to the internet and use a VPN to get to them instead, this can make it problematic for other services to access your Nightscout data.

For example, maybe you're using GlucoTracker to get your glucose number on your Apple Watch as a complication. Well, GlucoTracker can't access your Nightscout instance because it's not exposed to the internet. By using this project, you can automaticlaly upload your Nightscout data to S3 and point GlucoTracker at the S3 bucket instead.

## Security

Using this project will expose your Nightscout data to the internet. If you're not comfortable with that, you should not use this project.

I'm personally comfortable with this for a couple of reasons:

1. I don't think anyone will guess the URL, privacy through obscurity isn't great, but it's a thing.
2. I personally am not worried about a couple of blood glucose values being out there.
3. It's better than exposing my self hosted services to the internet.

## How it Works

Nightscout S3 Proxy reads entries from your Nightscout instance every 60 seconds (by default) and uploads the data to S3 at the bucket you've
specified. It creates a file at this path: `/api/v1/entries.json`. This corrresponds to the API endpoint for Nightscout entries. This way apps that use the Nightscout API can use this data.

## Usage

This project uses Docker to run. Here are some examples of getting it running.

### ENV VARS

| ENV VAR               | Description                                                                                                                              | Required | Default |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- |
| NIGHTSCOUT_HOST       | The URL to your Nightscout instance                                                                                                      | Yes      |         |
| NIGHTSCOUT_TOKEN      | An [access token](https://nightscout.github.io/nightscout/security/#create-authentication-tokens-for-users) for your Nightscout instance | Yes      |         |
| AWS_S3_BUCKET         | The S3 bucket you want to send to                                                                                                        | Yes      |         |
| AWS_ACCESS_KEY_ID     | Your AWS Access Key                                                                                                                      | Yes      |         |
| AWS_SECRET_ACCESS_KEY | Your AWS Secret Access Key                                                                                                               | Yes      |         |
| WAIT_IN_SECONDS       | Number of seconds between uploading data to S3                                                                                           | No       | 60      |

### CLI

```bash
+docker run \
--name nightscout-s3-proxy \
-e NIGHTSCOUT_HOST=http://192.168.2.411:1337 \
-e NIGHTSCOUT_TOKEN=XXXXXXXXXXXX \
-e AWS_S3_BUCKET=your-bucket-name \
-e AWS_ACCESS_KEY_ID=XXXXXXXXXXXX \
-e AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXX \
jonmaddox/nightscout-s3-proxy
```

### Docker Compose

```yaml
version: "3.1"
services:
  nightscout-s3-proxy:
    image: jonmaddox/nightscout-s3-proxy
    container_name: nightscout-s3-proxy
    environment:
      NIGHTSCOUT_HOST: "http://192.168.2.411:1337"
      NIGHTSCOUT_TOKEN: "XXXXXXXXXXXX"
      AWS_S3_BUCKET: "your-bucket-name"
      AWS_ACCESS_KEY_ID: "XXXXXXXXXXXX"
      AWS_SECRET_ACCESS_KEY: "XXXXXXXXXXXX"
```
