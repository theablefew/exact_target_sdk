module ExactTargetSDK
class ConfigureResponse

  attr_reader :OverallStatus, :OverallStatusMessage, :RequestID

  def initialize(response)
    response = response.to_hash[:configure_response_msg]
    @OverallStatus = response[:overall_status]
    @OverallStatusMessage = response[:overall_status_message]
    @RequestID = response[:request_id]
  end

end
end
