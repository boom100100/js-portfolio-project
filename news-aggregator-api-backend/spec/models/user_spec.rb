require 'rails_helper'

describe 'User' do

  before do
    @user = User.create(username: "myUser", password: "badPassword", location: "home")
    @topic1 = Topic.create(name: "myTopic")
    @topic2 = Topic.create(name: "myEndotopic")
    @link1 = Link.create(name: "some_news", url: "https://google.com", topic: @topic1, user: @user)
    @link2 = Link.create(name: "some_news", url: "https://google.com", topic: @topic2, user: @user)
  end

  it 'has a name' do
    expect(@user.username).to eq("myUser")
  end

  it 'has a password' do
    expect(@user.password).to eq("badPassword")
  end

  it 'has a location' do
    expect(@user.location).to eq("location")
  end

  it 'has many links' do
    expect(@user.links).to eq([@link1, @link2])
  end

  it 'has many topics, through links' do
    expect(@user.patients).to eq([@topic1, @topic2])
  end
end
