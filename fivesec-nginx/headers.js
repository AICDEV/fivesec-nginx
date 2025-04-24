function escapeJsonString(str) {
	return str
		.replace(/\\/g, '\\\\')  // backslashes
		.replace(/"/g, '\\"')    // double quotes
		.replace(/\u0008/g, '\\b') // backspace
		.replace(/\t/g, '\\t')   // tab
		.replace(/\n/g, '\\n')   // newline
		.replace(/\f/g, '\\f')   // form feed
		.replace(/\r/g, '\\r')   // carriage return
		.replace(/</g, '')       // optional: strip <
		.replace(/>/g, '');      // optional: strip >
}

function headers_to_json(r) {
	var headers = {};
	for (var h in r.headersIn) {
		headers[escapeJsonString(h)] = escapeJsonString(r.headersIn[h]);

	}
	return JSON.stringify(headers);
}


export default { headers_to_json };
