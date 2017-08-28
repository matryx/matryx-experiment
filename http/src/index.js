
var actions = require("./actions.js");

var express = require("express");

var app = express();

app.get("/", function (req, res) {
    res.send("HTTP API Matryx-Experiment endpoint");
});

app.post("/bounty/create", function (req, res) {
    var data = req.body;
    var startTime = data.startTime;
    var endTime = data.endTime;
    var roundsNb = data.roundsNb;
    var reviewDelay = data.reviewDelay;
    action.bounty.create(startTime, endTime, roundsNb, reviewDelay, function (success, result, error) {
        res.json({
            success: success,
            results: results,
            error: "" + error,
            inputs: {
                title: title,
                content: content,
            },
        });
    });
});

app.post("/submission/create", function (req, res) {
    var data = req.body;
    var title = data.title;
    var endTime = data.endTime;
    var roundsNb = data.roundsNb;
    var reviewDelay = data.reviewDelay;
    action.bounty.create(startTime, endTime, roundsNb, reviewDelay, function (success, result, error) {
        res.json({
            success: success,
            results: results,
            error: "" + error,
            inputs: {
                title: title,
                content: content,
            },
        });
    });
});
