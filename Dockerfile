FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install --fix-missing -y \ 
	postgresql-client \
  build-essential\
  curl \
  build-essential \
  libpq-dev

# Install nodejs and yarn
  RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn


COPY Gemfile /[APPNAME]/Gemfile
COPY Gemfile.lock /[APPNAME]/Gemfile.lock
ENV PATH="/[APPNAME]/bin:${PATH}"
WORKDIR /[APPNAME]

RUN gem install bundler && bundle install

  
RUN mkdir tmp && mkdir tmp/pids
ADD . /[APPNAME]
# Uncomment this!
#RUN chmod +x /[APPNAME]/bin/*

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-c", "config/puma.rb"]