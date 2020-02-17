# JS-Portfolio-Project

The purpose of this app is to aggregate news stories from reliable sources. The news stories will be aggregated in real time, and their content will be based on topics that are trending on Twitter.

The main page shows buttons that represent trending topics. When a user clicks a button, the page queries the backend for a real-time search of related news. If there are results, links to related stories appear under the topic.

Dependencies:
CORS
Twitter API
The Guardian API

Config:
Add CORS support.
Run bundle install for required gems.
Add api key and secret for Twitter API to news-aggregator-api-backend/app/controllers/topics_controller.rb#authenticate.
Add api key for The Guardian API to news-aggregator-api-backend/app/controllers/links_controller.rb#getNews.

Usage:
Endpoints are /links, /links/:id, /topics, and /topics/:id.
For GUI, open news-aggregator-api-frontend/index.html in a browser to use once you've configured the app.
