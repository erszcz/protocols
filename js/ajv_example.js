const Ajv = require("ajv/dist/jtd")
const ajv = new Ajv() // options can be passed, e.g. {allErrors: true}

const schema = {
  properties: {
    foo: {type: "int32"}
  },
  optionalProperties: {
    bar: {type: "string"}
  }
}


const validate = ajv.compile(schema)

const data = {
  foo: 1,
  bar: "abc"
}

const valid = validate(data)
if (valid) {
  console.log("ok")
} else {
  console.log(validate.errors)
}
