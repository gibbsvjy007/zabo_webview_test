function getReady() {
       console.log('getReady');
       console.log(window);

console.log('new datarrrr');
var open = window.XMLHttpRequest.prototype.open,
    send = window.XMLHttpRequest.prototype.send,
    onReadyStateChange;

function openReplacement(method, url, async, user, password) {
    var syncMode = async !== false ? 'async' : 'sync';
    return open.apply(this, arguments);
}

function sendReplacement(data) {
    console.log('Sending HTTP request data : ', data);

    if(this.onreadystatechange) {
        this._onreadystatechange = this.onreadystatechange;
    }
    this.onreadystatechange = onReadyStateChangeReplacement;
    return send.apply(this, arguments);
}

function onReadyStateChangeReplacement() {
    console.log('HTTP request ready state changed : ' + this.readyState + ' ' + this.readyState + ' ' + XMLHttpRequest.DONE);

    if (this._onreadystatechange) {
        return this._onreadystatechange.apply(this, arguments);
    }
}
window.XMLHttpRequest.prototype.open = openReplacement;
window.XMLHttpRequest.prototype.send = sendReplacement;
}

//(function() {
//    var proxied = XMLHttpRequest.prototype.open;
//    XMLHttpRequest.prototype.open = function() {
//        console.log( arguments );
//        return proxied.apply(this, [].slice.call(arguments));
//    };
//})();

//(function(open, send) {
//
//   // Closure/state var's
//   var xhrOpenRequestUrl;  // captured in open override/monkey patch
//   var xhrSendResponseUrl; // captured in send override/monkey patch
//   var responseData;       // captured in send override/monkey patch
//
//   //...overrides of the XHR open and send methods are now encapsulated within a closure
//
//   XMLHttpRequest.prototype.open = function(method, url, async, user, password) {
//      xhrOpenRequestUrl = url;     // update request url, closure variable
//      console.log("FSFSFS");
//      open.apply(this, arguments); // reset/reapply original open method
//   };
//
//   XMLHttpRequest.prototype.send = function(data) {
//
//      //...what ever code you need, i.e. capture response, etc.
//      if (this.readyState == 4 && this.status >= 200 && this.status < 300) {
//         xhrSendResponseUrl = this.responseURL;
//         responseData = this.data;  // now you have the data, JSON or whatever, hehehe!
//
//            console.log('HTTP request ready state changed : ' + this.readyState + ' ' + this.readyState + ' ' + XMLHttpRequest.DONE);
//
//      }
//      send.apply(this, arguments); // reset/reapply original send method
//   }
//
//})(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send)

getReady();
