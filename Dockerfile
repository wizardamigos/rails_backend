FROM ruby:2.2.0

RUN apt-get update -qq && apt-get install -y build-essential

#for postgres
RUN apt-get install -y libpq-dev

#for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev nodejs

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
RUN test -f $APP_HOME/tmp/pids/server.pid && rf $APP_HOME/tmp/pids/server.pid; true

ADD . $APP_HOME/

CMD bin/rails server --port 3000 --binding 0.0.0.0
