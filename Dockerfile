FROM alpine

ARG ONTEST

# Install dependencies for 'dig' and 'aws'
RUN apk add --no-cache bind-tools python py-pip
RUN pip install --upgrade awscli
RUN apk --purge del py-pip

# Set default environment variables
ENV AWS_DEFAULT_REGION us-west-2
ENV AWS_DEFAULT_OUTPUT json

# Copy ddns53 script and make it executable
COPY ddns53.sh /usr/local/bin/ddns53.sh
RUN chmod +x /usr/local/bin/ddns53.sh

# ONTEST: Copy ddns53 test script and make it executable
COPY ddns53.test.sh /usr/local/bin/ddns53.test.sh
RUN chmod +x /usr/local/bin/ddns53.test.sh
RUN [ -z "${ONTEST}" ] && rm /usr/local/bin/ddns53.test.sh || exit 0

# Run ddns53 every 15 minutes
RUN ln -fs /usr/local/bin/ddns53.sh /etc/periodic/15min/ddns53
CMD crond -l 2 -f