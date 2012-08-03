module ExactTargetSDK

class SubscriberList < APIObject

  property 'ID'
  property 'Status'
  property 'Action'

  validates 'Status', :inclusion => { :allow_nil => true, :in => Subscriber::STATUSES }
  validates 'Action', :inclusion => { :allow_nil => true, :in => %w{ create update } }

end

end
