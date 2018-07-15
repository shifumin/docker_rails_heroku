FROM ruby:2.5.1
ENV LANG C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       apt-transport-https \
                       libpq-dev \
                       postgresql-client \
                       vim \
                       --no-install-recommends

# node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

RUN mkdir /rails_app
WORKDIR /rails_app

COPY Gemfile /rails_app/Gemfile
COPY Gemfile.lock /rails_app/Gemfile.lock
COPY yarn.lock /rails_app/yarn.lock

RUN bundle install --jobs=4 --no-cache
COPY . /rails_app

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
