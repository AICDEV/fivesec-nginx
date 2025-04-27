function headers_to_json(r) {
    var headers = {};
    if (r.headersIn) {
        for (var h in r.headersIn) {
            var value = r.headersIn[h];
            if (value === undefined || value === null) {
                value = "";
            }
            headers[h] = value;
        }
    }
    return JSON.stringify(headers);
}

export default { headers_to_json };
