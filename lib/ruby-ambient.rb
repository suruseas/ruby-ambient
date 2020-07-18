# frozen_string_literal: true
require "ambient/version"

require 'net/http'
require 'json'

# This class is for communicating with Ambient API.
class Ambient
  attr_reader :channel_id
  attr_accessor :write_key, :read_key, :user_key

  BASE_URL = 'http://ambidata.io/api/v2/channels/%s'

  # Create instance.
  # 
  # @param [String] channel_id Channel ID for Ambient.
  # @option args [String] :write_key used when sending data.
  # @option args [String] :read_key used when receiving and getting prop.
  # @option args [String] :user_key unused
  def initialize(channel_id, **args)
    @channel_id = channel_id
    @base_url = BASE_URL % @channel_id

    @write_key = args[:write_key]
    @read_key = args[:read_key]
    @user_key = args[:user_key]
  end

  # Send sensor data to Ambient.
  #
  # @param [Object] data Hash or Array of Hash.
  # @return [Net::HTTPResponse]
  def send(data)
    data = ([] << data).flatten
    headers = { 'Content-Type': 'application/json' }
    uri = URI.parse("#{@base_url}/dataarray")

    post(uri, { writeKey: @write_key, data: data }.to_json, headers)
  end

  # Receive sensor data from Ambient.
  #
  # @option args [String] :date used when sending data
  # @option args [String] :start used when receiving and getting prop
  # @option args [String] :end unused
  # @option args [String] :n Specify the number of data to be read. The latest [:n] data are read.
  # @option args [String] :skip Available only when the N option is enabled. It skips the latest recent data and reads the [n] data after that.
  # @return [Array<Hash>] It skips [:skip] of the latest data and reads [:n] of the latest data after that.
  def read(**args)
    args = self.class.symbolize_keys(args)

    opt = {}
    opt[:readKey] = @read_key if @read_key

    if args.key?(:date)
      opt[:date] = args[:date]
    elsif args.key?(:start) && args.key?(:end)
      opt[:start] = args[:start]
      opt[:end] = args[:end]
    elsif args.key?(:n)
      opt[:n] = args[:n]
      opt[:skip] = args[:skip] if args.key?(:skip)
    end

    url = "#{@base_url}/data"
    url += '?' + opt.to_a.map { |k, v| "#{k}=#{v}" }.join('&') unless opt.empty?
    uri = URI.parse(url)

    res = JSON.parse(get(uri), symbolize_names: true)
    Array.new(res).reverse
  end

  # Receive channel information
  #
  # @return [Array<Hash>]
  def prop
    @prop ||= begin
      url = @base_url
      url += "?readKey=#{@read_key}" if @read_key
      uri = URI.parse(url)
      JSON.parse(get(uri), symbolize_names: true)
    end
  end

  class << self
    def symbolize_keys(hash)
      return hash unless hash&.is_a?(Hash)

      hash.map do |k, v|
        [
          k.to_sym,
          case v
          when Hash
            symbolize_keys(v)
          when Array
            v.each { |obj| symbolize_keys(obj) }
          else
            v
          end
        ]
      end.to_h
    end
  end

  private

  def post(uri, payload, headers = {})
    http = Net::HTTP.new(uri.host, uri.port)
    http.post(uri.path, payload, headers)
  end

  def get(uri)
    Net::HTTP.get(uri)
  end
end
