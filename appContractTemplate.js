exports.template = `pragma solidity ^0.4.24;

import "../honeyaccesscontrol/AccessControl.sol";
// Define a contract 'Supplychain'
contract SupplyChain is AccessControl {

    // Define 'owner'
    address owner;

    // Declare Counters
    {{for actions}}
    {{for properties}}{{if isCounter}}{{:type}} {{:name}}Index{{else}}{{/if}}{{/for}}{{/for}}


    // Declare Mappings of actions and counter properties
{{for actions}}    {{for properties ~action=#data}}{{if isCounter}}mapping ({{:type}} => {{:~action.name}}) {{:~action.name}}X{{:name}}\n{{else}}{{/if}}{{/for}}{{/for}}
    // Declare Mappings of actions and counter properties that exist
{{for actions}}    {{for properties ~action=#data}}{{if isCounter}}mapping ({{:type}} => bool) {{:~action.name}}_has_{{:name}}\n{{else}}{{/if}}{{/for}}{{/for}}

    // Declare Mappings of actions and unique properties
{{for actions}}    {{for properties ~action=#data}}{{if isUnique}}mapping ({{:type}} => {{:~action.name}}) {{:~action.name}}X{{:name}}\n{{else}}{{/if}}{{/for}}{{/for}}
    // Declare Mappings of actions and unique properties that exist
{{for actions}}    {{for properties ~action=#data}}{{if isUnique}}mapping ({{:type}} => bool) {{:~action.name}}_has_{{:name}}\n{{else}}{{/if}}{{/for}}{{/for}}

    // Declare Not Exist Errors
{{for actions}}    string private constant ERROR_{{:name.toUpperCase()}}_DOES_NOT_EXIST = "ERROR_{{:name.toUpperCase()}}_DOES_NOT_EXIST";\n{{/for}}

    // Declare Already Exist Errors
{{for actions}}    string private constant ERROR_{{:name.toUpperCase()}}_ALREADY_EXISTS = "ERROR_{{:name.toUpperCase()}}_ALREADY_EXISTS";\n{{/for}}

    string private constant ERROR_NOT_CONTRACT_OWNER = "ERROR_NOT_CONTRACT_OWNER";
    string private constant ERROR_SHIPPINGDOWNPAYMENT = "ERROR_SHIPPINGDOWNPAYMENT_MORE_THAN_SHIPPINGCOST";

{{for actions}}    struct {{:name}} {
{{for properties ~action=#data}}        {{:type}} {{:name}}; // {{:description}}\n{{/for}}    }\n
{{/for}}
    //Declare Events based on actions
{{for actions}}{{for events }}    event {{:name}} ({{for properties ~len=properties.length}}{{:type}} {{:name}}{{if #index < ~len -1}},{{/if}}{{/for}}){{/for}}\n{{/for}}

    // Define a modifer that checks to see if msg.sender == owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, ERROR_NOT_CONTRACT_OWNER);
        _;
    }

    // Define a modifer that verifies the Caller
    modifier verifyCaller (address _address) {
        require(msg.sender == _address);
        _;
    }

    //Verify mappings exists based on counters
{{for actions}}    {{for properties ~action=#data}}{{if isCounter}}modifier verify{{:~action.name}}_has_{{:name}} ({{:type}} _{{:name}}){
        require({{:~action.name}}_has_{{:name}}[_{{:name}}] == true, ERROR_{{:~action.name.toUpperCase()}}_DOES_NOT_EXIST);
        _;
    }\n{{else}}{{/if}}{{/for}}{{/for}}
    //Verify mappings exists based on unique identifiers
{{for actions}}    {{for properties ~action=#data}}{{if isUnique}}modifier verify{{:~action.name}}_has_{{:name}} ({{:type}} _{{:name}}){
        require({{:~action.name}}_has_{{:name}}[_{{:name}}] == true, ERROR_{{:~action.name.toUpperCase()}}_DOES_NOT_EXIST);
        _;
    }\n{{else}}{{/if}}{{/for}}{{/for}}

    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint _upc) {
        _;
        uint _price = harvests[_upc].productPrice;
        uint amountToReturn = msg.value - _price;
        harvests[_upc].buyerID.transfer(amountToReturn);
    }

    // In the constructor set 'owner' to the address that instantiated the contract
    // and set 'sku' to 1
    // and set 'upc' to 1
    constructor() public payable {
        owner = msg.sender;
        sku = 1;
        orderIdIndex = 1;
        quoteIdIndex = 1;
        purchaseIdIndex = 1;
        shipmentIdIndex = 1;
    }

    // Define a function 'kill' if required
    function kill() public {
        if (msg.sender == owner) {
          selfdestruct(owner);
        }
    }

    function addHarvester(address _who)
        public
        onlyOwner{
        addPermission(HARVEST_ROLE, _who, "");
    }

{{for actions}}
    function {{:name}}
    (
{{for properties ~len=properties.length}}{{if !isCounter && !isSender}}        {{:type}} {{:name}}{{if #getIndex() < ~len -1}},{{/if}}\n{{/if}}{{/for}}    )
    public {{if isPayable}}payable{{/if}}
    {
{{for requiredRoles}}        require(has({{:name}}, {{:grantedTo}}, ""), "MISSING {{:name}}");{{/for}}
{{for properties ~action=#data}}{{if isUnique}}
{{for ~action.requiredPermissions ~property=#data}}        require(has({{:name}}, {{:grantedTo}}, bytes32({{:~action.name.toLowerCase()}}_.{{:~property.name}}), "MISSING {{:name}}");
{{/for}}{{/if}}{{/for}}
{{for rules ~rule=#data}}        require({{for formulae}}{{:value}} {{/for}}, "{{:message}})";\n{{/for}}
{{for properties ~action=#data}}{{if isUnique}}        require({{:~action.name}}_has_{{:name}}[_{{:name}}] == false, ERROR_{{:~action.name.toUpperCase()}}_ALREADY_EXISTS);{{/if}}{{/for}}
        //Set Counter Variable
{{for properties ~action=#data}}{{if isCounter}}        {{:~action.name.toLowerCase()}}_.{{:name}} = {{:name}}Index;\n{{/if}}{{/for}}
        //Set Sender Variable
{{for properties ~action=#data}}{{if isSender}}        {{:~action.name.toLowerCase()}}_.{{:name}} = msg.sender;\n{{/if}}{{/for}}
        //Get foreign references
{{for foreignKeys}}        {{:action}} Storage {{:action.toLowerCase()}}_ = {{:action}}X{{:reference}}[{{:property}}];\n{{/for}}
{{for properties ~action=#data}}{{if !isCounter && !isSender}}        {{:~action.name.toLowerCase()}}_.{{:name}} = {{:name}};\n{{/if}}{{/for}}
        //
{{for properties ~action=#data}}{{if isCounter}}        {{:~action.name}}_has_{{:name}}[{{:~action.name.toLowerCase()}}_.{{:name}}] = true;\n{{else}}{{/if}}{{/for}}
{{for properties ~action=#data}}{{if isUnique}}        {{:~action.name}}_has_{{:name}}[{{:~action.name.toLowerCase()}}_.{{:name}}] = true;\n{{else}}{{/if}}{{/for}}
{{if isPayable}}        //Transfer value
        uint balance = msg.value
{{for pay}}        {{:from}}_.{{:recipient}}.transfer({{:from}}_.{{:value}});{{/for}}
        if(balance > 0) {
            msg.sender.transfer(balance);
        }{{/if}}

        //Add roles and permissions
        {{for awardedRoles}}addPermission({{:name}}, {{:grantedTo}});{{/for}}
        {{for properties ~action=#data}}{{if isUnique}}
{{for ~action.awardedPermissions ~property=#data}}        addPermission({{:name}}, {{:grantedTo}}, bytes32({{:~action.name.toLowerCase()}}_.{{:~property.name}}));
{{/for}}{{/if}}{{/for}}
        //Emit Events
{{for events ~action=#data}}        emit {{:name}}({{for properties ~len=properties.length}}{{:~action.name.toLowerCase()}}_.{{:name}}{{if #index < ~len -1}}, {{/if}}{{/for}}){{/for}}\n
        //Increament Counter
{{for properties ~action=#data}}{{if isCounter}}        {{:name}}Index = {{:name}}Index + 1;\n{{/if}}{{/for}}
    }
{{/for}}

{{for actions}}
{{for properties ~action=#data}}{{if isCounter}}    fetch{{:~action.name}}X{{:name}}({{:type}} _{{:name}}) public view verify{{:~action.name}}_has_{{:name}}(_{{:name}}) returns
    (
{{for ~action.properties}}{{if !isCounter}}        {{:type}} {{:name}};\n{{/if}}{{/for}}    )
    {
        {{:~action.name}} storage {{:~action.name.toLowerCase()}}_ = {{:~action.name}}X{{:name}}[_{{:name}}];
{{for ~action.properties}}{{if !isCounter}}        {{:name}} = {{:~action.name.toLowerCase()}}_.{{:name}};\n{{/if}}{{/for}}    }\n{{/if}}{{/for}}{{/for}}

{{for actions}}
{{for properties ~action=#data}}{{if isUnique}}    fetch{{:~action.name}}X{{:name}}({{:type}} _{{:name}}) public view verify{{:~action.name}}_has_{{:name}}(_{{:name}}) returns
    (
{{for ~action.properties}}{{if !isUnique}}        {{:type}} {{:name}};\n{{/if}}{{/for}}    )
    {
        {{:~action.name}} storage {{:~action.name.toLowerCase()}}_ = {{:~action.name}}X{{:name}}[_{{:name}}];
{{for ~action.properties}}{{if !isUnique}}        {{:name}} = {{:~action.name.toLowerCase()}}_.{{:name}};\n{{/if}}{{/for}}    }\n{{/if}}{{/for}}{{/for}}

}
`

