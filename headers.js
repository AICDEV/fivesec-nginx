function headers_to_json(r) {
    return JSON.stringify(r.headersIn)
}

export default {headers_to_json};