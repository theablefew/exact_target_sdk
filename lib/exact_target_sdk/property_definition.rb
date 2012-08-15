module ExactTargetSDK
class PropertyDefinition < APIObject

  PROPERTY_TYPES = %w[ boolean datetime double string ]

  property 'Name', :required => true
  property 'PropertyType', :required => true
  property 'IsCreatable'
  property 'IsEditable'
  property 'IsFilterable'
  property 'IsRequired'

  validates 'PropertyType', :inclusion => { :allow_nil => true, :in => PROPERTY_TYPES }

end
end
