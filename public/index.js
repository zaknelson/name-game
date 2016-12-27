function chooseName(names, i) {
  return function() {
    if (getSelectionText() !== "") {
      return;
    }
    var loserIndex = (i == 0) ? 1 : 0;
    postJSON({
      winners: [names[i].innerText],
      losers: [names[loserIndex].innerText]
    }, "/games", function() {
      getNewRandomNames(names);
    }, function() {
      getNewRandomNames(names);
    });
  };
}

function getNewRandomNames(names) {
  loadJSON("/names/random", function(json) {
    for (var i = 0; i < names.length; i++) {
      names[i].innerText = json[i];
    }
  }, function() {
    console.log("Error");
  });
}

function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

function loadJSON(path, success, error) {
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        if (success) {
          success(JSON.parse(xhr.responseText));
        }    
      } else {
        if (error) {
          error(xhr);
        }    
      }
    }
  };
  xhr.open("GET", path, true);
  xhr.send();
}

function postJSON(data, path, success, error) {
  var xhr = new XMLHttpRequest();
  
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        if (success) {
          var result;
          try {
            JSON.parse(xhr.responseText)
          } catch(e) {
          }
          success(result);
        }    
      } else {
        if (error) {
          error(xhr);
        }    
      }
    }
  };

  xhr.open("POST", path, true);
  xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
  xhr.send(JSON.stringify(data));
}

function main() {
  var names = document.querySelectorAll(".big-name");
  var thumbsUp = document.querySelectorAll(".thumbs-up");
  var neither = document.querySelector(".neither");
  getNewRandomNames(names);
  for (var i = 0; i < names.length; i++) {
    names[i].onclick = chooseName(names, i);
    thumbsUp[i].onclick = chooseName(names, i);
  }

  neither.onclick = function() {
    postJSON({
      winners: [],
      losers: [names[0].innerText, names[1].innerText]
    }, "/games", function() {
      getNewRandomNames(names);
    }, function() {
      getNewRandomNames(names);
    });
  }
}

document.addEventListener("DOMContentLoaded", function(event) { 
  main();
});

