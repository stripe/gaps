require 'mongo_mapper'

module Gaps
  module DB
    class DBError < StandardError; end
    class UniqueKeyViolation < DBError; end

    def self.init
      # Initialize even if we're not encrypting, since we may need to
      # unencrypt some records.
      if configatron.db.key?(:encryption_key)
        SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
          cipher_name: 'aes-128-cbc',
          key: configatron.db.encryption_key,
          encoding: :base64strict
        )
      end

      MongoMapper.database = configatron.db.database
      MongoMapper.connection = Mongo::MongoClient.from_uri(configatron.db.mongodb_url, pool_size: 5)

      Cache.build_index
      Group.build_index
      User.build_index
    end

    require_relative 'db/base'
    require_relative 'db/cache'
    require_relative 'db/group'
    require_relative 'db/set'
    require_relative 'db/state'
    require_relative 'db/user'
  end
end
