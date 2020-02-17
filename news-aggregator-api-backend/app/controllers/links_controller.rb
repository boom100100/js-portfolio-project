#require 'news-api'
require "open-uri"

class LinksController < ApplicationController
  #@@time;
  def index


    #get topics, date
    topics = Topic.all
    date = format


    #if links updated within the hour: if (@@time - date[1]).abs != 0
    #if there are trending topics
    if topics
      #@@time = format[1]
      destroy

      #search each topic
      topics.each do |topic|
        name = topic.name.gsub(/[\W\s]/, "")

        #authenticate news
        articles = getNews(topic.name, date[0])

        articles["response"]["results"].each do |result|

        #results = news.get_everything(q: "#{name}", from: "#{date[0]}", sortBy: "popularity")
        #results.each do |result|

          #make link for each search result; assign topic
          Link.create(name: result['webTitle'], url: result['webUrl'], topic: topic).save
        end
      end

      render json: Link.all, only: [:id, :name, :url], include: [:topic]
    else
      render ''
    end
  end

  def show
    link = Link.find_by(:id => params[:id])
    render json: link, only: [:id, :name, :url], include: [:topic]
  end

  def new
    @link = Link.new
  end

  def create

  end

  def destroy
    Link.delete_all
  end

  private
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
    url = "https://content.guardianapis.com/search?q=#{topic.gsub(/[\s\W]/,'_')}&api-key="

    #url = "https://api-beta.civicfeed.com/news/search?q=#{topic.gsub(/[\s\W]/,'_')}&from=#{date[0]}&results=30?x-api-key=2E1osqNeA413TDVuOOjU06kXSjgBy5qxPKnbhMt2"
    #url = "https://api.currentsapi.services/v1/search?keywords=#{topic.gsub(/[\s\W]/,'_')}&language=en&apiKey="
    #url = "https://newsapi.org/v2/everything?q=#{topic.gsub(/[\s\W]/,'_').downcase}?domains=aljazeera.com,arstechnica.com,arynews.tv,apnews.com,afr.com,axios.com,bbc.co.uk,bloomberg.com,businessinsider.com,cbc.ca,cbsnews.com,cnbc.com,cnn.com,elmundo.es,engadget.com,fortune.com,fourfourtwo.com,medicalnewstoday.com,msnbc.com,mtv.com,nationalgeographic.com,nbcnews.com,news24.com,newscientist.com,newsweek.com,nymag.com,nextbigfuture.com,nfl.com,nhl.com,politico.com,recode.net,reuters.com,rte.ie,wsj.com,nytimes.com&from=#{date}&apiKey="
    article_serialized = open(url).read
    articles = JSON.parse(article_serialized)
    articles
  end
end
