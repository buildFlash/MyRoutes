let functions = require('firebase-functions');
let admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.getPlaces = functions.https.onRequest((req, res) => {
	const uid = req.query.uid;
	const ref = admin.database().ref('users').child(uid);

	ref.child("places").once('value').then(function(snap) {
		console.log(snap.val());
		if (snap.val() != null) {
			let places = snap.val()
			let respArray = [];
			Object.keys(places).forEach(function(key) {
				console.log(key);
				respArray.push(places[key]);
			})
			var obj = {};
			obj["isEmpty"] = false;
			obj["places"] = respArray;
			res.send(obj);
		} else {
			var obj = {};
			obj["isEmpty"] = true;
			res.send(obj);
		}
	});
});
