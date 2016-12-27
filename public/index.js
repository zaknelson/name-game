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

function chooseName(names, i) {
  return function() {
    var loserIndex = (i == 0) ? 1 : 0;
    postJSON({
      winner: names[i].innerText,
      loser: names[loserIndex].innerText
    }, "/games", function() {
      getNewRandomNames(names);
    }, function() {
      getNewRandomNames(names);
    })
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

function main() {
  var names = document.querySelectorAll(".big-name");
  getNewRandomNames(names);
  for (var i = 0; i < names.length; i++) {
    names[i].onclick = chooseName(names, i);
  }
}

document.addEventListener("DOMContentLoaded", function(event) { 
  main();
});

