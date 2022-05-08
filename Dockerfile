FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential apt-utils ghostscript
RUN apt-get update -qq && apt-get install -y mongo-tools || true
RUN gem install bundler -v 2.2.31
RUN mkdir /onion-api
WORKDIR /onion-api
COPY Gemfile /onion-api/Gemfile
COPY Gemfile.lock /onion-api/Gemfile.lock
RUN bundle install
COPY . /onion-api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]