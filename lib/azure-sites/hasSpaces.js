var cli = require("./lib/cli/cli");
var site = cli.categories.site;

var subscription = require(process.env.AZURE_CONFIG_DIR + "/config.json").subscription;

site.doSpacesGet({
    subscription: subscription
}, function(err, spaces) {
    if (err) {
        console.error(err.toString());
        process.exit(1);
    }
        
    if (err || !spaces || !spaces.length)
        process.exit(200);
});