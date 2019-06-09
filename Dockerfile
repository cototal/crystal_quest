FROM polysphere/crystal

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN shards && crystal build --release src/crystal_quest.cr
