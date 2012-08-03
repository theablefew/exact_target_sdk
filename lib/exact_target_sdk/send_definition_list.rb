module ExactTargetSDK

class SendDefinitionList < AudienceItem

  # FIXME: These properties are actually defined on AudienceItem, but the current property functionality does not
  # support inheritance, so we have to redeclare them.
  property 'ObjectID'
  property 'List'
  property 'SendDefinitionListType'
  property 'CustomObjectID'
  property 'DataSourceTypeID'

end

end
