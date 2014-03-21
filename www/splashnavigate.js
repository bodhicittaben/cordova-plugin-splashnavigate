var exec = require('cordova/exec');

var splashnavigate = {
    go:function(url) {
        exec(null, null, "SplashNavigate", "go", [url]);
    }
};

module.exports = splashnavigate;