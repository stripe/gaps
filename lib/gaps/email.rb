require 'restclient'
require 'mail'
require 'mandrill'

module Gaps
  module Email
    include Chalk::Log

    def self.send_email(opts)
      mail = Mail.new(opts)

      if configatron.notify.send_email
        if configatron.notify.provider == "mandrill"
          begin
            mandrill = Mandrill::API.new configatron.notify.api_key
            message = {
              "from_email"=>opts[:from],
              "text"=>opts[:body],
              "to"=> [{"email"=>opts[:to],
                       "type"=>"to"}],
              "subject"=>opts[:subject],
            }
            async = false
            result = mandrill.messages.send message

          rescue Mandrill::Error => e
            # Mandrill errors are thrown as exceptions
            log.error "A mandrill error occurred: #{e.class} - #{e.message}"
            raise
          end
        else
          mail.delivery_method :sendmail
          mail.deliver!
        end
      else
        log.info("Would have sent", email: mail.to_s)
      end
    end
  end
end
