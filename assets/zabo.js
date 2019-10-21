// Inject jQuery if not
function injectjQuery() {
      var script = document.createElement("script");
      script.id = "my_injection";
      script.src = "https://code.jquery.com/jquery-3.3.1.min.js";

      document.head.appendChild(script);
}

function getNetworkCalls() {
    console.log('calling method');
    $(document).ajaxSuccess(function() {
      console.log("An individual AJAX call has completed successfully");
    });
     console.log('invoking method');
    //or...

    $(document).ajaxComplete(function() {
      console.log("ALL current AJAX calls have completed");
    });
}

function getReady() {
    injectjQuery();
    console.log('loaded');
    getNetworkCalls();
}

getReady();