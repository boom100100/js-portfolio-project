class TopicsController < ApplicationController

  def index
    #authenticate
    client = authenticate

    #gets trends
    topics = client.trends().to_h
    if topics.as_json['trends'].length > 0
      destroy #gets rid of previous topics
      topics.as_json['trends'].each do |topic|
        create(topic['name']) #creates topic objects
        #puts topic['name']
      end
      render json: Topic.all, only: ['id','name']
    else
      render 'Collecting trending topics failed.'
    end
  end

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

  private
  def authenticate
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ""
      config.consumer_secret     = ""
    end
  end

end
