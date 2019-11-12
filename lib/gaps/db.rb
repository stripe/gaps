require 'mongo_mapper'

module Gaps
  module DB
    class DBError < StandardError; end
    class UniqueKeyViolation < DBError; end

    def self.init
      MongoMapper.database = configatron.db.database
      MongoMapper.connection = Mongo::MongoClient.from_uri(
        configatron.db.mongodb_url,
        pool_size: [configatron.cache.pool_size, 5].max
      )

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
