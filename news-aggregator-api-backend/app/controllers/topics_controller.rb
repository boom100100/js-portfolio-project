class TopicsController < ApplicationController

  #gets and shows full group of trending topics.
  #data taken from twitter api.
  def index
    @topics = Topic.all
    @topics ? render( json: @topics, only: ['id','name']) : render( 'Collecting trending topics failed.')
  end

  #shows a single topic and its associated links.
  def show
    topic = Topic.find_by(id: params[:id])
    if topic
      render json: topic, only: [:id, :name], include: [:links]
    else
      render plain: 'Topic not found.'
    end
  end

  def new
    Topic.new
  end

  def create(name)
    Topic.create(name: name).save
  end

  def destroy
    Topic.delete_all
  end

  def refresh
    #authenticate
    client = authenticate
    topics = client.trends().to_h
    
    if topics.as_json['trends'].length > 0

      destroy #gets rid of previous topics
      topics.as_json['trends'].each do |topic|
        create(topic['name']) #creates topic objects
      end
      render json: Topic.all, only: ['id','name']

    else
      render 'Collecting trending topics failed.'
    end
  end

  private
  def authenticate
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:api_secret_key]
    end
  end

end
