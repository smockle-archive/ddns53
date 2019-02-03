# ddns53

Set an A record in an AWS Route 53 Hosted Zone to the current public IP address

# Setup

Attach the following policy to an IAM User (replacing `<HOSTED_ZONE_ID>`):

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:GetHostedZone",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/<HOSTED_ZONE_ID>",
                "arn:aws:route53:::change/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "route53:ListHostedZones",
            "Resource": "*"
        }
    ]
}
```

# Usage

```Bash
# With environment file
docker run -d --restart=unless-stopped --net=host --name=ddns53 --env-file=~/.ddns53/config smockle/ddns53

# Without environment file
docker run -d \
    --restart=unless-stopped \
    --net=host \
    --name=ddns53 \
    -e HOSTED_ZONE_ID \
    -e DOMAIN \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_DEFAULT_REGION \
    -e AWS_DEFAULT_OUTPUT \
    smockle/ddns53
```

# Developing

```Bash
# Build and run, without tags, then clean
docker run --rm -it $(docker build -q .)

# Build and run, with tags, without cleaning
docker build -t ddns53-devel . && docker run -it ddns53-devel
```
