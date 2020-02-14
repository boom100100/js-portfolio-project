require 'rails_helper'

describe 'Topic' do

  before do
    @topic = Topic.create(name: "myTopic")

    @user = User.create(username: "myUser", password_digest: "badPassword", location: "home")
    @link = Link.create(name: "some_news", url: "https://google.com", topic: @topic, user: @user)
  end

  it 'has a name' do
    expect(@topic.name).to eq('myTopic')
  end

  it 'has many users through links' do
    expect(@topic.users).to eq([@user])
  end

  it 'has many links' do
      expect(@user.links).to eq([@link])
    end



end
