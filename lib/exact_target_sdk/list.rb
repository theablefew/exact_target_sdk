module ExactTargetSDK

class List < APIObject

  property 'ID'
  property 'ListName', :required => true
  property 'Description'
  property 'CreatedDate'
  property 'CategoryID'
  array_property 'Subscribers'
end

end
