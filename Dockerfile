FROM ruby:3.2.2-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    imagemagick \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY ./config/policy.xml /etc/ImageMagick-6/policy.xml

RUN bundle install --jobs 4 --retry 3

COPY . .

RUN mkdir -p /app/logs && touch /app/logs/app.log

ENTRYPOINT ["bin/file_processor"]

CMD ["-h"]