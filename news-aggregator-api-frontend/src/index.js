//Initiates fetches and frontend rendering.
function doAll(){
  getTrends('http://localhost:3000/topics/', makeTrendCards);
}

//Fetcher. Called twice: once without trendName, once with it.
function doFetch(url, fcn, trendName){
  return fetch(url)
    .then(function(response) {
      return response.json();
    })
    .then(function(json){
      fcn(json, trendName);
  });
}

function getTrends(url, fcn) {
  doFetch(url, fcn);
}


function makeTrendCards(json) {
  //console.log(json);
  for (let trend of json){
    let h4 = document.createElement("h4");
    h4.id = trend['name'];
    h4.appendChild(document.createTextNode(trend['name']));
    document.getElementById('main').appendChild(h4);
    searchTrends(trend['name']);
  }
}

function searchTrends(trendName){
  doFetch('http://localhost:3000/links/', makeLinkCards, trendName);
}

class TrendCard{
  all = []
  constructor(){
    all.push(this)
  }
}
class LinkCard{
  all = []
}

function makeLinkCards(json, trendName){
  //console.log(json);
  if (Object.keys(json).length < 0){
    for (let story of json){
      let a = document.createElement('a');

      //which of these two?
      a.appendChild(document.createTextNode(story.name));
      a.text = story.name;

      a.title = story.name;
      a.href = story.url;

      document.getElementById(trendName).appendChild(a);
    }
  }
}

document.addEventListener('DOMContentLoaded', function() {
  doAll();
});
