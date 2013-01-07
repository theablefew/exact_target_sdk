require 'guid'
require 'savon'
require 'timeout'

module ExactTargetSDK

# Provides an object-oriented API to ExactTarget's Web Service API
# (http://docs.code.exacttarget.com/020_Web_Service_Guide)
#
# With few exceptions, ruby conventions for capitalization are ignored and those
# outlined in the guide linked above are used. This is done in an attempt to be
# as transparent as possible, so that the API may be used by referring only to
# the guide linked above.
class Client

  # Constructs a client.
  #
  # Any of the options documented in ExactTargetSDK#config may be overridden
  # using the options parameter.
  #
  # Since ExactTarget's API is stateless, constructing a client object will not
  # make any remote calls.
  def initialize(options = {})
    self.config = {
    }.merge!(ExactTargetSDK.config).merge!(options)

    Savon.configure do |c|
      c.logger = config[:logger]
      c.raise_errors = false
    end

    initialize_client!
  end

  # Invokes the Create method.
  #
  # The provided arguments should each be sub-classes of APIObject, and each
  # provided object will be created in order.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns a CreateResponse object.
  def Create(*args)
    # TODO: implement and accept CreateOptions

    api_objects = args

    response = execute_request 'Create' do |xml|
      xml.CreateRequest do
        xml.Options  # TODO: support CreateOptions

        api_objects.each do |api_object|
          xml.Objects "xsi:type" => api_object.type_name do
            api_object.render!(xml)
          end
        end
      end
    end

    CreateResponse.new(response)
  end

  # Invokes the Retrieve method.
  #
  # Note that this implementation abstracts away the useless RetrieveRequest
  # sub-wrapper, and introduces a RequestResponse wrapper to contain the
  # output parameters.
  #
  # Does not currently support requests that have too many results for one
  # batch.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns a RetrieveResponse object.
  def Retrieve(object_type_name, filter=nil, properties=nil, options=nil)
    object_type_name = object_type_name.type_name if object_type_name.respond_to?(:type_name)

    properties ||= ['ID']
    options ||= {}

    query_all_accounts = options.delete(:QueryAllAccounts)
    client_id = options.delete(:ClientID)

    if query_all_accounts && client_id
      raise StandardError, 'Passed a ClientID for Retrieve with QueryAllAccounts enabled'
    end

    response = execute_request 'Retrieve' do |xml|
      xml.RetrieveRequestMsg do
        xml.RetrieveRequest do
          xml.Options

          if query_all_accounts
            xml.QueryAllAccounts(true)
          end

          if client_id
            xml.ClientIDs do
              xml.ID(client_id)
            end
          end

          xml.ObjectType object_type_name

          properties.each do |property|
            xml.Properties(property)
          end

          unless filter.nil?
            xml.Filter "xsi:type" => filter.type_name do
              filter.render!(xml)
            end
          end
        end
      end
    end

    RetrieveResponse.new(response)
  end


  def RetrieveMore(object_type_name, continue_request_id, filter=nil, properties)
    object_type_name = object_type_name.type_name if object_type_name.respond_to?(:type_name)
    response = execute_request 'Retrieve' do |xml|
      xml.RetrieveRequestMsg do
        xml.RetrieveRequest do
          xml.Options
          xml.ContinueRequest continue_request_id.to_s
          xml.ObjectType object_type_name

          properties.each do |property|
            xml.Properties(property)
          end

          unless filter.nil?
            xml.Filter "xsi:type" => filter.type_name do
              filter.render!(xml)
            end
          end
        end
      end
    end

    RetrieveResponse.new(response)
  end

  # Invokes the Update method.
  #
  # The provided arguments should each be sub-classes of APIObject, and each
  # provided object will be updated in order.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns an UpdateResponse object.
  def Update(*args)
    # TODO: implement and accept UpdateOptions

    api_objects = args

    response = execute_request 'Update' do |xml|
      xml.UpdateRequest do
        xml.Options  # TODO: support UpdateOptions

        api_objects.each do |api_object|
          xml.Objects "xsi:type" => api_object.type_name do
            api_object.render!(xml)
          end
        end
      end
    end

    UpdateResponse.new(response)
  end


  # Invokes the Create method with the UpdateAdd option set.
  #
  # The provided arguments should each be sub-classes of APIObject, and each
  # provided object will be created or updated in order.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns an CreateResponse object.
  def UpdateAdd(*args)
    # TODO: implement and accept CreateOptions

    api_objects = args

    response = execute_request 'Create' do |xml|
      xml.CreateRequest do
        xml.Options do
          xml.SaveOptions do
            xml.SaveOption do
              xml.PropertyName('*')
              xml.SaveAction('UpdateAdd')
            end
          end
        end

        api_objects.each do |api_object|
          xml.Objects "xsi:type" => api_object.type_name do
            api_object.render!(xml)
          end
        end
      end
    end

    CreateResponse.new(response)
  end


  # Invokes the Delete method.
  #
  # The provided arguments should each be sub-classes of APIObject, and each
  # provided object will be updated in order.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns a DeleteResponse object.
  def Delete(*args)
    # TODO: implement and accept DeleteOptions

    api_objects = args

    response = execute_request 'Delete' do |xml|
      xml.DeleteRequest do
        xml.Options  # TODO: support DeleteOptions

        api_objects.each do |api_object|
          xml.Objects "xsi:type" => api_object.type_name do
            api_object.render!(xml)
          end
        end
      end
    end

    DeleteResponse.new(response)
  end

  # Invokes the Perform method.
  #
  # The provided arguments should each be definitions that are sub-classes
  # of APIObject.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns a PerformResponse object.
  def Perform(action, *args)
    # TODO: implement and accept PerformOptions

    definitions = args

    response = execute_request 'Perform' do |xml|
      xml.PerformRequestMsg do
        xml.Action action

        xml.Definitions do
          definitions.each do |definition|
            xml.Definition "xsi:type" => definition.type_name do
              definition.render!(xml)
            end
          end
        end

        xml.Options  # TODO: support PerformOptions
      end
    end

    PerformResponse.new(response)
  end

  # Invokes the Configure method.
  #
  # The provided arguments should each be definitions that are sub-classes
  # of APIObject.
  #
  # Possible exceptions are:
  #   HTTPError         if an HTTP error (such as a timeout) occurs
  #   SOAPFault         if a SOAP fault occurs
  #   Timeout           if there is a timeout waiting for the response
  #   InvalidAPIObject  if any of the provided objects don't pass validation
  #
  # Returns a ConfigureResponse object.
  def Configure(action, *args)
    # TODO: implement and accept ConfigureOptions

    configurations = args

    response = execute_request 'Configure' do |xml|
      xml.ConfigureRequestMsg do
        xml.Action action

        xml.Configurations do
          configurations.each do |configuration|
            xml.Configure "xsi:type" => configuration.type_name do
              configuration.render!(xml)
            end
          end
        end

        xml.Options  # TODO: support ConfigureOptions
      end
    end

    ConfigureResponse.new(response)
  end

  def logger
    config[:logger]
  end

  private

  attr_accessor :config, :client

  # Constructs and saves the savon client using provided config.
  def initialize_client!
    _sdk_config = config
    self.client = ::Savon::Client.new do
      wsdl.endpoint = _sdk_config[:endpoint]
      wsdl.namespace = _sdk_config[:namespace]
      http.open_timeout = _sdk_config[:open_timeout]
      http.read_timeout = _sdk_config[:read_timeout]
    end
  end

  # Builds the SOAP request for the given method, delegating body
  # rendering to the provided block.
  #
  # Handles errors and re-raises with appropriate sub-class of
  # ExactTargetSDK::Error.
  #
  # Returns the raw savon response.
  def execute_request(method)
    _sdk_config = config
    begin
      response = client.request(method) do
        soap.xml do |xml|
          xml.s :Envelope,
              "xmlns" => _sdk_config[:namespace],
              "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
              "xmlns:s" => "http://www.w3.org/2003/05/soap-envelope",
              "xmlns:a" => "http://schemas.xmlsoap.org/ws/2004/08/addressing",
              "xmlns:o" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" do

            xml.s :Header do
              xml.a :Action, method, "s:mustUnderstand" => "1"
              xml.a :MessageID, "uuid:#{Guid.new.to_s}"
              xml.a :ReplyTo do
                xml.a :Address, "http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous"
              end
              xml.a :To, _sdk_config[:endpoint], "s:mustUnderstand" => "1"
              xml.o :Security, "s:mustUnderstand" => "1" do
                xml.o :UsernameToken, "o:Id" => "test" do
                  xml.o :Username, _sdk_config[:username]
                  xml.o :Password, _sdk_config[:password]
                end
              end
            end

            xml.s :Body do
              yield(xml)
            end
          end
        end

        logger.info soap.instance_variable_get(:@xml) if _sdk_config[:log_soap_body]
      end

      if response.http_error?
        raise HTTPError, response.http_error.to_s
      end

      if response.soap_fault?
        raise SOAPFault, response.soap_fault.to_s
      end

      response
    rescue ::Timeout::Error => e
      timeout = ::ExactTargetSDK::TimeoutError.new("#{e.message}; open_timeout: #{config[:open_timeout]}; read_timeout: #{config[:read_timeout]}")
      timeout.set_backtrace(e.backtrace)
      raise timeout
    rescue Exception => e
      raise e
    end
  end

end

end
