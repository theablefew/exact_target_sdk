module ExactTargetSDK

class ListSubscriber < APIObject

  property 'ListID'
  property 'SubscriberKey'
  property 'Status'

  validates 'Status', :inclusion => { :allow_nil => true, :in => Subscriber::STATUSES }

end

end
