exports.name = `{{:name}}`
exports.key = `{{:key}}`
exports.actions = `{{for actions}}
    {{:name}}
{{/for}}
`

exports.actionProperties =
`
{{for actions}}
    {{for properties}}
        {{:name}}
    {{/for}}
{{/for}}
`

exports.actionPropertiesCounters =
`
{{for actions}}
    --- ---
    {{:name}}
    {{for properties}}{{if isCounter}}{{:name}}{{else}}{{/if}}{{/for}}
{{/for}}
`

exports.actionPropertiesIsUnique =
`
{{for actions}}
    --- ---
    {{:name}}
    {{for properties}}{{if isUnique}}{{:name}}{{else}}{{/if}}{{/for}}
{{/for}}
`