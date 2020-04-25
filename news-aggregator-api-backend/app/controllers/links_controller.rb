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

  #called when spa user clicks trend button
  #only refreshes in 15-minute intervals
  def refresh
    #puts '#############################' + params[:trend_name] + '#############################'
    topic = Topic.find_by(name: params[:trend_name])

    if topic
      #Link.all.destroy_all

      #refresh links if no refresh occurred in last 15 minutes, or if no links
      do_refresh = nil
      if topic.links.length > 0
        do_refresh = true#(topic.links[0].created_at.since(60*15) <= DateTime.now)
      else
        do_refresh = true
      end

      if do_refresh

        date = format

        #search topic
        #authenticate news
        articles = getNews(topic.name, date[0])
        #puts '############################' + articles.to_s + '############################'
        if articles && articles.size > 0

          #delete all links for this topic
          topic.links.destroy_all if topic.links
          articles.each do |result|
            #make link for each search result; assign topic
            Link.create(name: result.title, url: result.url, topic: topic)
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
    formatted_strings = ["#{month}-#{day}-#{year}", "#{hour}"]#{hour}"] #&to=#{year}-#{month}-#{day}", "#{hour}"]
    formatted_strings
  end

  def getNews(topic, date)
    topic = topic.gsub(/[\s\W]/,'+')
    topic = topic.gsub(/[A-Z]{1,}/,'+\0')
    #puts '#################################' + topic + '#################################'
    newsapi = News.new(Rails.application.credentials.news_api[:api_key])
    all_articles = newsapi.get_everything(q: topic,sources: 'abc-news,bbc-news,espn,fortune,medical-news-today,national-geographic,politico,reuters,techcrunch,usa-today',from: date,language: 'en')
    #puts all_articles
    #article_serialized = open(url).read
    #articles = JSON.parse(all_articles.to_s)
    all_articles#articles
  end

end
