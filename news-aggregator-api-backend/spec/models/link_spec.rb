require 'rails_helper'

describe 'Link' do

  before do
    @topic = Topic.create(name: "myTopic")
    @user = User.create(username: "myUser", password_digest: "badPassword", location: "home")

    @link = Link.create(name: "some_news", url: "https://google.com", topic: @topic, user: @user)

  end

  it 'has a name' do
    expect(@link.name).to eq('some_news')
  end

  it 'has a url' do
    expect(@link.url).to eq ('https://google.com')
  end

  it 'has many topics' do
    expect(@link.topic).to eq(@topic)
  end

  it 'has many users' do
      expect(@link.user).to eq(@user)
    end



end
