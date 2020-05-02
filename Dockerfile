FROM ruby:2.7.1-alpine
ENV LANG C.UTF-8

RUN mkdir /app
WORKDIR /app

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
        ruby-dev \
        build-base \
        libxml2-dev \
        libxslt-dev \
        pcre-dev \
        libffi-dev \
        postgresql-dev \
        tzdata

RUN gem install --no-document bundler && \
    gem update --system

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs=4 --retry=3

COPY . .

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
