//const util = require('./util');
const util = require('/opt/util');

exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: {id: util.getfakeuid(), user:"lokal-bela"},
        //body: {id: 777, user:"lokal-bela"},
    };
    return response;
};

//console.log(exports.handler({}))

if (!!process.env.LAMBDA_TASK_ROOT) {
    console.log("I'm on AWS Lambda");
} else {
    exports.handler({}).then(value => { console.log(value); })
    .catch(err => { console.log("ERR: " + err) });
}