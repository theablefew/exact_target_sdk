module ExactTargetSDK

class AudienceItem < APIObject

  SEND_DEFINITION_LIST_TYPES = %w[ SourceList ExclusionList DomainExclusion OutOutList ]
  DATA_SOURCE_TYPES = %w[ List CustomObject DomainExclusion SalesForceReport SalesForceCampaign FilterDefinition OptOutList ]

  property 'ObjectID'
  property 'List'
  property 'SendDefinitionListType'
  property 'CustomObjectID'
  property 'DataSourceTypeID'

  validates 'SendDefinitionListType', :inclusion => { :allow_nil => true, :in => SEND_DEFINITION_LIST_TYPES }
  validates 'DataSourceTypeID', :inclusion => { :in => DATA_SOURCE_TYPES }

end

end
