FROM ubuntu:14.04

RUN apt-get update && apt-get install -y nodejs

COPY index.js /
COPY node_modules /node_modules

CMD ["nodejs", "index.js"]
