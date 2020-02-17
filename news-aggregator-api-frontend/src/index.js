//Initiates fetches and frontend rendering.
let jsonData;
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
    let div = document.createElement("div");
    let button = document.createElement("button");

    let noResults = document.createElement("div");
    noResults.innerHTML = "This trend returned 0 results.";
    let searching = document.createElement("div");
    searching.innerHTML = "Searching...";
    noResults.id = trend['name'] + "-no-results";
    searching.id = trend['name'] + "-searching";
    noResults.class = "no-results";
    searching.class = "searching";
    noResults.style.display = "none";
    searching.style.display = "none";


    div.id = trend['name'] + "-div";
    button.id = trend['name'] + "-button";
    button.appendChild(document.createTextNode(trend['name']));

    div.appendChild(button);
    div.appendChild(noResults);
    div.appendChild(searching);

    div.appendChild(document.createElement('br'));
    document.getElementById('main').appendChild(div);
    button.onclick = function(){
      searchTrends(trend['name']);
    };

  }
}

function searchTrends(trendName){
  document.getElementById(trendName + "-no-results").style.display = "none";
  document.getElementById(trendName + "-searching").style.display = "block";
  console.log("Searching for: " + trendName);
  doFetch('http://localhost:3000/links/', makeLinkCards, trendName);
}



function makeLinkCards(json, trendName){
  jsonData = json;
  console.log("Link set: " + trendName);
  console.log(json)
  //if (json.count < 0){
  let results = 0;
  for (let story of json){
    //console.log("story['topic']['name'] === trendName?" + (story['topic']['name'] === trendName))

    if (story['topic']['name'] === trendName) {
      results++;
      console.log(story['topic']['name'] + ", " + story['name'])
      let a = document.createElement('a');

      //which of these two?
      //a.appendChild(document.createTextNode(story.name));
      a.target = "_blank";
      a.text = story.name;

      a.title = story.name;
      a.href = story.url;

      document.getElementById(trendName + "-div").appendChild(document.createElement('br'));
      document.getElementById(trendName + "-div").appendChild(a);

    }
  }
  document.getElementById(trendName + "-searching").style.display = "none";
  if (results === 0){
    //alert: no results.
    document.getElementById(trendName + "-no-results").style.display = "block";
  }
  //} else {
    //console.log('No json data.')
  //}
}

document.addEventListener('DOMContentLoaded', function() {
  doAll();
});
