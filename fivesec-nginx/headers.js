function headers_to_json(r) {
    var headersArray = Object.keys(r.headersIn).map(function(name) {
        return { name: name, value: r.headersIn[name] };
    });
    return JSON.stringify(headersArray);
}

export default { headers_to_json };
