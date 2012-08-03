module ExactTargetSDK

class SendClassification < APIObject
  SEND_CLASSIFICATION_TYPES = %w[ Operational Marketing ]

  property 'CustomerKey'
  property 'SendClassificationType'
  property 'Name'
  property 'Description'
  property 'SenderProfile'
  property 'DeliveryProfile'
  property 'HonorPublicationListOptOutsForTransactionalSends'
  property 'SendPriority'
  property 'ArchiveEmail'

  validates 'SendClassificationType', :inclusion => { :allow_nil => true, :in => SEND_CLASSIFICATION_TYPES }
end

end
