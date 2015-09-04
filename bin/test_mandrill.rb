#!/usr/bin/env ruby
require File.expand_path('../lib/gaps', File.dirname(__FILE__))

Gaps.init

Gaps::Email.send_email(
  :to => configatron.notify.to,
  :from => configatron.notify.from,
  :subject => "[gaps] Testing email",
  :body => <<EOF
A new mailing list was just created:

You can subscribe to this list at:

You can view more details about this group at:

EOF
)
