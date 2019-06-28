var jsrender = require('jsrender');
var template = require('./appContractTemplate')
var sampledata = require('./sampleData');

function generateCode(template, data){
    var tmpl = jsrender.templates(template); // Compile template from string
    return tmpl.render(data); // Render
}


const code = generateCode(template["template"], sampledata.smartContract)

//Only for test
const fs = require('fs');
fs.writeFile("./code/test.sol", code, function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
});