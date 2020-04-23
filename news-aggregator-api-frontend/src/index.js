let jsonData;

//Initiates fetches and frontend rendering.
function doAll(){
  getTrends('http://localhost:3000/topics', makeTrendCards);
  setUpRefreshTrends();
}

function setUpRefreshTrends(){
  const refreshTrends = function(){
    ElementClass.getElement('main').innerHTML = '';
    getTrends('http://localhost:3000/topics/refresh', makeTrendCards);
  }
                    //(parent, tag, id, className, onClick, display, innerHTML, href, title, target)
  new ElementClass('top-bar', 'button', 'refresh-button', 'button', refreshTrends, null, 'Refresh Trends', null, null, null);
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

//post fetcher
//has backend query third-party api for news stories search
function doPostFetch(maker, trendName){
  configurationObject = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    },
    body: JSON.stringify({
      trend_name: trendName
    })
  };
  return fetch('http://localhost:3000/links/refresh', configurationObject)
    .then(function(response) {
      return response.json();
    })
    .then(function(json){
      //console.log(json);
      maker(json, trendName);
  });
}

function getTrends(url, fcn) {
  doFetch(url, fcn);
}


function makeTrendCards(json) {

  for (let trend of json){
    //(parent, tag, id, className, onClick, display, innerHTML, href, title, target)
    new ElementClass('main', 'div', trend['name'] + "-div", 'card', null, null, null, null, null, null);

    const buttonOnClick = function(){
      searchTrends(trend['name']);
    };

    new ElementClass(trend['name'] + "-div", 'button', trend['name'] + "-button", 'button', buttonOnClick, null, trend['name'], null, null, null);

    new ElementClass(trend['name'] + "-div", 'div', trend['name'] + "-no-results", 'no-results', null, 'none', 'This trend returned 0 results.', null, null, null);
    new ElementClass(trend['name'] + "-div", 'div', trend['name'] + "-searching", 'searching', null, 'none', 'Searching...', null, null, null);

    new ElementClass(trend['name'] + "-div", 'br', '', '', null, null, null, null, null, null);

  }
}

function searchTrends(trendName){
  ElementClass.resizeElement(trendName + '-div');
  ElementClass.removeLinks(trendName + '-div');
  ElementClass.setDisplay(trendName + "-searching");
  console.log("Searching for: " + trendName);

  //post to my api to call third-party api
  doPostFetch(makeLinkCards, trendName);

}



function makeLinkCards(json, trendName){
  jsonData = json;
  console.log("Link set: " + trendName);
  console.log(json)

  let results = 0;

  for (let story of json){

    if (story['topic']){
      if (story['topic']['name'] === trendName) {
        results++;
        console.log(story['topic']['name'] + ", " + story['name'])
        new ElementClass(trendName + "-div",'br','','',null,null,null, null, null, null);

        //(parent, tag, id, className, onClick, display, innerHTML, href, title, target)
        new ElementClass(trendName + "-div",'a','','',null,null,story.name, story.url, story.name, '_blank');

      }
    }
  }
  ElementClass.setDisplay(trendName + "-searching");

  if (results === 0){
    //alert: no results.
    ElementClass.setDisplay(trendName + "-no-results");
    setTimeout(function(){
      ElementClass.setDisplay(trendName + "-no-results");
    }, 10000);
  }
}

class ElementClass {

  constructor(parent, tag, id, className, onClick, display, innerHTML, href, title, target){
    let me = document.createElement(tag);
    me.id = id;
    me.className = className;
    me.onclick = onClick;
    me.style.display = display;
    me.innerHTML = innerHTML;
    me.href = href;
    me.title = title;
    me.target = target;

    ElementClass.getElement(parent).appendChild(me);

  }
  static setDisplay(id){
    let element = ElementClass.getElement(id);
    element.style.display == "none" ? element.style.display = "block" : element.style.display = "none";
  }
  static getElement(id){
    return document.getElementById(id);
  }

  static resizeElement(id){
    ElementClass.getElement(id).style.display = 'block';
  }

  static removeLinks(id){
    let toRemove = [...ElementClass.getElement(id).getElementsByTagName('br'),
     ...ElementClass.getElement(id).getElementsByTagName('a')];

    if (toRemove.length > 0){
      for (let i = 0; i < toRemove.length; i++){
        toRemove[i].parentNode.removeChild(toRemove[i]);
      }
    }
  }

}

document.addEventListener('DOMContentLoaded', function() {
  doAll();
});
