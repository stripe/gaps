FROM ruby:2.1.5
RUN useradd app && mkdir /home/app
MAINTAINER Greg Brockman <gdb@stripe.com>
ENV PORT 3500
EXPOSE 3500
ADD Gemfile* /gaps/
RUN cd /gaps && bundle install --path vendor/bundle
ADD . /gaps
# If you're running a version of docker before .dockerignore
RUN rm -f /gaps/site.yaml*
# Need app to write to /usr/local so the bundle command works
RUN chown -R app: /gaps /usr/local
USER app
ENV HOME /home/app
ENV RACK_ENV production
WORKDIR /gaps
CMD ["bin/hk-runner"]
