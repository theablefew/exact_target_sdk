module ExactTargetSDK

class EmailSendDefinition < APIObject

  property 'ObjectID'
  property 'CustomerKey'
  property 'Name', :required => true
  property 'SendDefinitionList'
  property 'SendClassification'
  property 'Email'
  property 'CategoryID'
  property 'DeduplicateByEmail'
  property 'SenderProfile'

end

end
