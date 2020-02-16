require 'news-api'

class LinksController < ApplicationController
  def index
    #authenticate news
    news = News.new("")

    #get topics, date
    topics = Topic.all
    date = format

    if topics
      destroy
      #search each topic
      topics.each do |topic|
        name = topic.name
        news.get_everything(q: "monopoly", from: "#{date}", sortBy: "popularity").as_json(only: ['name', 'title', 'url']).each do |result|

          #make link for each search result
          Link.create(name: result['title'], url: result['url'], topic: topic).save
        end
      end

      render json: Link.all, only: [:id, :name, :url, :topic]
    else
      render ''
    end
    #render json: news.get_everything(q: "news", from: "#{date}", sortBy: "popularity").as_json(only: ['name', 'title', 'url'])
    #render json: news.get_everything(q: "news", from: "#{date}", sortBy: "popularity")

    #news.get_everything(q: "#{topic}", from: "#{date}", sortBy: "popularity")
    #render json: news.get_sources(country: 'us', language: 'en'), only: ['id','name', 'url']
    #render json: Link.all, only: ['id','name', 'url']
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
    year = time.year
    month = time.month
    day = time.day
    formatted_string = "#{year}-#{month}-#{day-2}&to=#{year}-#{month}-#{day}"
    formatted_string
  end
end
