require "open-uri"

class LinksController < ApplicationController

  #shows all links and corresponding topics
  def index
    if params[:topic_id]
      @links = Topic.find_by(id: params[:topic_id]).links
    else
      @links = Link.all
    end
    #may not have topics if topics refreshed.
    if @links
      render json: @links, only: [:id, :name, :url], include: [:topic]
    else
      render plain: 'Could not find links.'
    end
  end

  def show
    link = Link.find_by(id: params[:id])
    render json: link, only: [:id, :name, :url], include: [:topic]
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.create(link_params)
  end

  def destroy
    Link.destroy
  end

  #
  def refresh
    #puts '#############################' + params[:trend_name] + '#############################'
    topic = Topic.find_by(name: params[:trend_name])

    if topic
      #Link.all.destroy_all

      #refresh links if no refresh occurred in last 15 minutes, or if no links
      do_refresh = nil
      if topic.links.length > 0
        do_refresh = (topic.links[0].created_at.since(60*15) <= DateTime.now)
      else
        do_refresh = true
      end

      if do_refresh

        date = format

        #search topic
        #authenticate news
        articles = getNews(topic.name, date[0])
        if articles["response"]["results"].length > 0

          #delete all links for this topic
          topic.links.destroy_all if topic.links

          articles["response"]["results"].each do |result|
            #make link for each search result; assign topic
            Link.create(name: result['webTitle'], url: result['webUrl'], topic: topic)
          end
        end
      end

      #redirect with parameter
      #filters links to a specific topic's links
      redirect_to links_path, topic_id: topic.id#render json: @links, only: [:id, :name, :url], include: [:topic]

    else
      render plain: 'Could not find links for posted topic.'
    end
  end

  private

  def link_params
    params.require(:link).permit(:name, :url, :topic)
  end

  def format
    time = Time.now
    year = time.strftime("%Y")
    month = time.strftime("%m")
    day = time.day
    hour = time.hour
    formatted_strings = ["#{year}-#{month}-#{day}", "#{hour}"]#{hour}"] #&to=#{year}-#{month}-#{day}", "#{hour}"]
    formatted_strings
  end

  def getNews(topic, date)
    topic = topic.gsub(/[\s\W]/,'+')
    topic = topic.gsub(/[A-Z]{1,}/,'+\0')
    #puts '#################################' + topic + '#################################'
    url = "https://content.guardianapis.com/search?q=#{topic}&api-key=#{Rails.application.credentials.guardian[:api_key]}"

    article_serialized = open(url).read
    articles = JSON.parse(article_serialized)
    articles
  end
end
