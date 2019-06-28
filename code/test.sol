pragma solidity ^0.4.24;

import "../honeyaccesscontrol/AccessControl.sol";
// Define a contract 'Supplychain'
contract SupplyChain is AccessControl {

    // Define 'owner'
    address owner;

    // Declare Counters
    
    uint skuIndex
    uint orderIdIndex
    uint quoteIdIndex
    uint purchaseIdIndex
    uint shipmentIdIndex
    uint deliveryIdIndex


    // Declare Mappings of actions and counter properties
    mapping (uint => Harvest) HarvestXsku
    mapping (uint => Order) OrderXorderId
    mapping (uint => Quote) QuoteXquoteId
    mapping (uint => Purchase) PurchaseXpurchaseId
    mapping (uint => Shipment) ShipmentXshipmentId
    mapping (uint => Delivery) DeliveryXdeliveryId

    // Declare Mappings of actions and counter properties that exist
    mapping (uint => bool) Harvest_has_sku
    mapping (uint => bool) Order_has_orderId
    mapping (uint => bool) Quote_has_quoteId
    mapping (uint => bool) Purchase_has_purchaseId
    mapping (uint => bool) Shipment_has_shipmentId
    mapping (uint => bool) Delivery_has_deliveryId


    // Declare Mappings of actions and unique properties
    mapping (uint => Harvest) HarvestXupc
    mapping (uint => Order) OrderXupc
    mapping (uint => Quote) QuoteXorderId
    mapping (uint => Purchase) PurchaseXquoteId
    mapping (uint => Shipment) ShipmentXpurchaseId
    mapping (uint => Delivery) DeliveryXshipmentId

    // Declare Mappings of actions and unique properties that exist
    mapping (uint => bool) Harvest_has_upc
    mapping (uint => bool) Order_has_upc
    mapping (uint => bool) Quote_has_orderId
    mapping (uint => bool) Purchase_has_quoteId
    mapping (uint => bool) Shipment_has_purchaseId
    mapping (uint => bool) Delivery_has_shipmentId


    // Declare Not Exist Errors
    string private constant ERROR_HARVEST_DOES_NOT_EXIST = "ERROR_HARVEST_DOES_NOT_EXIST";
    string private constant ERROR_ORDER_DOES_NOT_EXIST = "ERROR_ORDER_DOES_NOT_EXIST";
    string private constant ERROR_QUOTE_DOES_NOT_EXIST = "ERROR_QUOTE_DOES_NOT_EXIST";
    string private constant ERROR_PURCHASE_DOES_NOT_EXIST = "ERROR_PURCHASE_DOES_NOT_EXIST";
    string private constant ERROR_SHIPMENT_DOES_NOT_EXIST = "ERROR_SHIPMENT_DOES_NOT_EXIST";
    string private constant ERROR_DELIVERY_DOES_NOT_EXIST = "ERROR_DELIVERY_DOES_NOT_EXIST";


    // Declare Already Exist Errors
    string private constant ERROR_HARVEST_ALREADY_EXISTS = "ERROR_HARVEST_ALREADY_EXISTS";
    string private constant ERROR_ORDER_ALREADY_EXISTS = "ERROR_ORDER_ALREADY_EXISTS";
    string private constant ERROR_QUOTE_ALREADY_EXISTS = "ERROR_QUOTE_ALREADY_EXISTS";
    string private constant ERROR_PURCHASE_ALREADY_EXISTS = "ERROR_PURCHASE_ALREADY_EXISTS";
    string private constant ERROR_SHIPMENT_ALREADY_EXISTS = "ERROR_SHIPMENT_ALREADY_EXISTS";
    string private constant ERROR_DELIVERY_ALREADY_EXISTS = "ERROR_DELIVERY_ALREADY_EXISTS";


    string private constant ERROR_NOT_CONTRACT_OWNER = "ERROR_NOT_CONTRACT_OWNER";
    string private constant ERROR_SHIPPINGDOWNPAYMENT = "ERROR_SHIPPINGDOWNPAYMENT_MORE_THAN_SHIPPINGCOST";

    struct Harvest {
        uint sku; // Stock Keeping Unit (SKU)
        uint upc; // Universal Product Code (UPC), generated by the Harvester, goes on the package, can be verified by the Buyer
        address harvesterId; // Metamask-Ethereum address of the Harvester
        address originBeekeeperId; // Metamask-Ethereum address of the BeeKeeper
        string originBeekeeperName; // BeeKeeper Name
        string originFarmInformation; // BeeKeeper Information
        string originFarmLatitude; // Farm Latitude
        string originFarmLongitude; // Farm Longitude
        uint quantity; // Quantity in milliliters
        uint productId; // Product ID potentially a combination of upc + sku
        string productNotes; // Product Notes
        uint productPrice; // Product Price
        address shipperId; // Metamask-Ethereum address of the Shipper
        address buyerId; // Metamask-Ethereum address of the Buyer
    }

    struct Order {
        uint orderId; // 
        address buyerId; // 
        uint upc; // 
        uint quantity; // 
    }

    struct Quote {
        uint quoteId; // 
        uint orderId; // 
        uint upc; // 
        uint price; // 
        address shipperId; // 
        uint shippingCost; // 
        uint shippingDownPayment; // 
        uint date; // 
    }

    struct Purchase {
        uint purchaseId; // 
        uint quoteId; // 
        uint orderId; // 
        uint upc; // 
        uint shipmentId; // 
        uint date; // 
    }

    struct Shipment {
        uint shipmentId; // 
        address shipper; // 
        uint purchaseId; // 
        uint quoteId; // 
        uint orderId; // 
        uint upc; // 
        uint date; // 
        bool delivered; // 
        uint dateDelivered; // 
    }

    struct Delivery {
        uint deliveryId; // 
        uint shipmentId; // 
        uint purchaseId; // 
        uint quoteId; // 
        uint orderId; // 
        uint upc; // 
        uint date; // 
    }


    //Declare Events based on actions
    event Harvested (uint sku,uint upc)
    event PlacedOrder (uint upc)
    event MadeQuote (uint orderId,uint price)
    event Purchased (uint purchaseId)
    event Shipped (uint shipmentId)
    event Delivered (uint deliveryId)


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
    modifier verifyHarvest_has_sku (uint _sku){
        require(Harvest_has_sku[_sku] == true, ERROR_HARVEST_DOES_NOT_EXIST);
        _;
    }
    modifier verifyOrder_has_orderId (uint _orderId){
        require(Order_has_orderId[_orderId] == true, ERROR_ORDER_DOES_NOT_EXIST);
        _;
    }
    modifier verifyQuote_has_quoteId (uint _quoteId){
        require(Quote_has_quoteId[_quoteId] == true, ERROR_QUOTE_DOES_NOT_EXIST);
        _;
    }
    modifier verifyPurchase_has_purchaseId (uint _purchaseId){
        require(Purchase_has_purchaseId[_purchaseId] == true, ERROR_PURCHASE_DOES_NOT_EXIST);
        _;
    }
    modifier verifyShipment_has_shipmentId (uint _shipmentId){
        require(Shipment_has_shipmentId[_shipmentId] == true, ERROR_SHIPMENT_DOES_NOT_EXIST);
        _;
    }
    modifier verifyDelivery_has_deliveryId (uint _deliveryId){
        require(Delivery_has_deliveryId[_deliveryId] == true, ERROR_DELIVERY_DOES_NOT_EXIST);
        _;
    }

    //Verify mappings exists based on unique identifiers
    modifier verifyHarvest_has_upc (uint _upc){
        require(Harvest_has_upc[_upc] == true, ERROR_HARVEST_DOES_NOT_EXIST);
        _;
    }
    modifier verifyOrder_has_upc (uint _upc){
        require(Order_has_upc[_upc] == true, ERROR_ORDER_DOES_NOT_EXIST);
        _;
    }
    modifier verifyQuote_has_orderId (uint _orderId){
        require(Quote_has_orderId[_orderId] == true, ERROR_QUOTE_DOES_NOT_EXIST);
        _;
    }
    modifier verifyPurchase_has_quoteId (uint _quoteId){
        require(Purchase_has_quoteId[_quoteId] == true, ERROR_PURCHASE_DOES_NOT_EXIST);
        _;
    }
    modifier verifyShipment_has_purchaseId (uint _purchaseId){
        require(Shipment_has_purchaseId[_purchaseId] == true, ERROR_SHIPMENT_DOES_NOT_EXIST);
        _;
    }
    modifier verifyDelivery_has_shipmentId (uint _shipmentId){
        require(Delivery_has_shipmentId[_shipmentId] == true, ERROR_DELIVERY_DOES_NOT_EXIST);
        _;
    }


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


    function Harvest
    (
        uint _upc,
        address _originBeekeeperId,
        string _originBeekeeperName,
        string _originFarmInformation,
        string _originFarmLatitude,
        string _originFarmLongitude,
        uint _quantity,
        uint _productId,
        string _productNotes,
        uint _productPrice,
        address _shipperId,
        address _buyerId
    )
    public
    {
        require(Harvest_has_upc[_upc] == false, ERROR_HARVEST_ALREADY_EXISTS);
        //Set Counter Variable
        harvest_.sku = skuIndex;

        //Set Sender Variable
        harvest_.harvesterId = msg.sender;

        harvest_.upc = upc;
        harvest_.originBeekeeperId = originBeekeeperId;
        harvest_.originBeekeeperName = originBeekeeperName;
        harvest_.originFarmInformation = originFarmInformation;
        harvest_.originFarmLatitude = originFarmLatitude;
        harvest_.originFarmLongitude = originFarmLongitude;
        harvest_.quantity = quantity;
        harvest_.productId = productId;
        harvest_.productNotes = productNotes;
        harvest_.productPrice = productPrice;
        harvest_.shipperId = shipperId;
        harvest_.buyerId = buyerId;

        //
        Harvest_has_sku[harvest_.sku] = true;

        Harvest_has_upc[harvest_.upc] = true;

        //Add permissions
        addPermission(Harvestor_of_, msg.sender, bytes32(harvest_.upc));

        //Emit Events
        emit Harvested(harvest_.sku, harvest_.upc)

        //Increament Counter
        skuIndex = skuIndex + 1;

    }

    function Order
    (
        address _buyerId,
        uint _upc,
        uint _quantity
    )
    public
    {
        require(Order_has_upc[_upc] == false, ERROR_ORDER_ALREADY_EXISTS);
        //Set Counter Variable
        order_.orderId = orderIdIndex;

        //Set Sender Variable

        order_.buyerId = buyerId;
        order_.upc = upc;
        order_.quantity = quantity;

        //
        Order_has_orderId[order_.orderId] = true;

        Order_has_upc[order_.upc] = true;

        //Add permissions
        addPermission(Order_of_, msg.sender, bytes32(order_.upc));

        //Emit Events
        emit PlacedOrder(order_.upc)

        //Increament Counter
        orderIdIndex = orderIdIndex + 1;

    }

    function Quote
    (
        uint _orderId,
        uint _upc,
        uint _price,
        address _shipperId,
        uint _shippingCost,
        uint _shippingDownPayment,
        uint _date
    )
    public
    {
        require(Quote_has_orderId[_orderId] == false, ERROR_QUOTE_ALREADY_EXISTS);
        //Set Counter Variable
        quote_.quoteId = quoteIdIndex;

        //Set Sender Variable

        quote_.orderId = orderId;
        quote_.upc = upc;
        quote_.price = price;
        quote_.shipperId = shipperId;
        quote_.shippingCost = shippingCost;
        quote_.shippingDownPayment = shippingDownPayment;
        quote_.date = date;

        //
        Quote_has_quoteId[quote_.quoteId] = true;

        Quote_has_orderId[quote_.orderId] = true;

        //Add permissions
        addPermission(Buyer_of_, buyerId, bytes32(quote_.orderId));

        //Emit Events
        emit MadeQuote(quote_.orderId, quote_.price)

        //Increament Counter
        quoteIdIndex = quoteIdIndex + 1;

    }

    function Purchase
    (
        uint _quoteId,
        uint _orderId,
        uint _upc,
        uint _shipmentId,
        uint _date
    )
    public
    {
        require(Purchase_has_quoteId[_quoteId] == false, ERROR_PURCHASE_ALREADY_EXISTS);
        //Set Counter Variable
        purchase_.purchaseId = purchaseIdIndex;

        //Set Sender Variable

        purchase_.quoteId = quoteId;
        purchase_.orderId = orderId;
        purchase_.upc = upc;
        purchase_.shipmentId = shipmentId;
        purchase_.date = date;

        //
        Purchase_has_purchaseId[purchase_.purchaseId] = true;

        Purchase_has_quoteId[purchase_.quoteId] = true;

        //Add permissions
        addPermission(Shipper_of_, shipperId, bytes32(purchase_.quoteId));

        //Emit Events
        emit Purchased(purchase_.purchaseId)

        //Increament Counter
        purchaseIdIndex = purchaseIdIndex + 1;

    }

    function Shipment
    (
        address _shipper,
        uint _purchaseId,
        uint _quoteId,
        uint _orderId,
        uint _upc,
        uint _date,
        bool _delivered,
        uint _dateDelivered
    )
    public
    {
        require(Shipment_has_purchaseId[_purchaseId] == false, ERROR_SHIPMENT_ALREADY_EXISTS);
        //Set Counter Variable
        shipment_.shipmentId = shipmentIdIndex;

        //Set Sender Variable

        shipment_.shipper = shipper;
        shipment_.purchaseId = purchaseId;
        shipment_.quoteId = quoteId;
        shipment_.orderId = orderId;
        shipment_.upc = upc;
        shipment_.date = date;
        shipment_.delivered = delivered;
        shipment_.dateDelivered = dateDelivered;

        //
        Shipment_has_shipmentId[shipment_.shipmentId] = true;

        Shipment_has_purchaseId[shipment_.purchaseId] = true;

        //Add permissions
        addPermission(Reciever_of_, buyerId, bytes32(shipment_.purchaseId));

        //Emit Events
        emit Shipped(shipment_.shipmentId)

        //Increament Counter
        shipmentIdIndex = shipmentIdIndex + 1;

    }

    function Delivery
    (
        uint _shipmentId,
        uint _purchaseId,
        uint _quoteId,
        uint _orderId,
        uint _upc,
        uint _date
    )
    public
    {
        require(Delivery_has_shipmentId[_shipmentId] == false, ERROR_DELIVERY_ALREADY_EXISTS);
        //Set Counter Variable
        delivery_.deliveryId = deliveryIdIndex;

        //Set Sender Variable

        delivery_.shipmentId = shipmentId;
        delivery_.purchaseId = purchaseId;
        delivery_.quoteId = quoteId;
        delivery_.orderId = orderId;
        delivery_.upc = upc;
        delivery_.date = date;

        //
        Delivery_has_deliveryId[delivery_.deliveryId] = true;

        Delivery_has_shipmentId[delivery_.shipmentId] = true;

        //Add permissions

        //Emit Events
        emit Delivered(delivery_.deliveryId)

        //Increament Counter
        deliveryIdIndex = deliveryIdIndex + 1;

    }


    // Define a function 'harvestItem' that allows a farmer to mark an harvest 'Harvested'
    function harvestItem(uint _upc, address _originBeekeeperID, string _originBeekeeperName, string _originFarmInformation, string  _originFarmLatitude, string  _originFarmLongitude, uint _quantity, string  _productNotes) public
    onlyHarvester()
    {
        require(harvestUPCs[_upc] == false, ERROR_HARVEST_ALREADY_EXISTS);
        // Add the new harvest as part of Harvest
        Harvest storage harvest_ = harvests[_upc];
        harvest_.sku = sku;
        harvest_.upc = _upc;
        harvest_.ownerID = owner;
        harvest_.originBeekeeperID = _originBeekeeperID;
        harvest_.originBeekeeperName = _originBeekeeperName;
        harvest_.originFarmInformation = _originFarmInformation;
        harvest_.originFarmLatitude = _originFarmLatitude;
        harvest_.originFarmLongitude = _originFarmLongitude;
        harvest_.quantity = _quantity;
        harvest_.productNotes = _productNotes;
        harvest_.harvesterId = msg.sender;

    }

    function placeOrder(uint _upc, uint quantity) public
    harvestExists(_upc)
    // Anybody can Place an Order
    {
        Order storage order_ = orders[orderIdIndex];
        order_.orderId = orderIdIndex;
        order_.buyerId = msg.sender;
        order_.upc = _upc;
        order_.quantity = quantity;
        orderIds[orderIdIndex] = true;
        addPermission(ORDER_OF_ROLE, msg.sender, bytes32(orderIdIndex));

        emit PlacedOrder(orderIdIndex, quantity);

        orderIdIndex = orderIdIndex + 1;
    }

    // Define a function 'packItem' that allows a farmer to mark an harvest 'Packed'
    function sendQuote(uint _orderId, uint _price, address _shipperId, uint _shippingCost,uint _shippingDownPayment) public
    onlyHarvester()
    orderExists(_orderId)
    {

        require(_shippingDownPayment <= _shippingCost, ERROR_SHIPPINGDOWNPAYMENT);
        Order storage order_ = orders[_orderId];
        require(has(HARVESTER_OF_ROLE, msg.sender, bytes32(order_.upc)), "Missing HARVESTER_OF_ROLE");
        Quote storage quote_ = quotes[quoteIdIndex];
        quote_.quoteId = quoteIdIndex;
        quote_.orderId = _orderId;
        quote_.upc = order_.upc;
        quote_.price = _price;
        quote_.shipperId = _shipperId;
        quote_.shippingCost = _shippingCost;
        quote_.shippingDownPayment = _shippingDownPayment;
        quote_.date = now;
        quoteIds[quoteIdIndex] = true;

        addPermission(BUYER_ROLE, order_.buyerId, "");
        addPermission(BUYER_OF_ROLE, order_.buyerId, bytes32(quote_.quoteId));

        emit SentQuote(quoteIdIndex);
        quoteIdIndex = quoteIdIndex + 1;
    }

    // Define a function 'sellItem' that allows a farmer to mark an harvest 'ForSale'
    function purchase(uint _quoteId) public
    quoteExists(_quoteId)
    onlyBuyer()
    hasPermission(BUYER_OF_ROLE, msg.sender, bytes32(_quoteId) ,"Missing BUYER_OF_ROLE") payable
    {
        Quote storage quote_ = quotes[_quoteId];
        Purchase storage purchase_ = purchases[purchaseIdIndex];
        purchase_.quoteId = _quoteId;
        purchase_.purchaseId = purchaseIdIndex;
        purchase_.orderId = quote_.orderId;
        purchase_.upc = quote_.upc;
        purchase_.date = now;
        purchaseIds[purchaseIdIndex] = true;

        quote_.shipperId.transfer(quote_.shippingDownPayment);
        if(msg.value > quote_.shippingDownPayment) {
            msg.sender.transfer(msg.value - quote_.shippingDownPayment);
        }

        addPermission(SHIPPER_ROLE, quote_.shipperId, "");
        addPermission(SHIPPER_OF_ROLE, quote_.shipperId, bytes32(purchase_.purchaseId));

        emit Purchased(purchaseIdIndex);
        purchaseIdIndex = purchaseIdIndex + 1;
    }

    // Define a function 'ship' that allows the harvester to mark an harvest 'Shipped'
    // Use the above modifers to check if the harvest is sold
    function ship(uint _purchaseId) public
      purchaseExists(_purchaseId)
      onlyShipper()
      hasPermission(SHIPPER_OF_ROLE, msg.sender, bytes32(_purchaseId) ,"Missing SHIPPER_OF_ROLE")
    {

        Purchase storage purchase_ = purchases[_purchaseId];
        Shipment storage shipment_ = shipments[shipmentIdIndex];
        shipment_.shipmentId = shipmentIdIndex;
        shipment_.purchaseId = _purchaseId;
        shipment_.quoteId = purchase_.quoteId;
        shipment_.orderId = purchase_.orderId;
        shipment_.upc = purchase_.upc;
        shipment_.shipper = msg.sender;
        shipment_.date = now;
        shipmentIds[shipmentIdIndex] = true;

        Order storage order_ = orders[shipment_.orderId];
        addPermission(RECIEVER_OF_ROLE, order_.buyerId, bytes32(shipment_.shipmentId));

        emit Shipped(shipmentIdIndex);
        shipmentIdIndex = shipmentIdIndex + 1;

    }

    // Define a function 'receiveItem' that allows the shipper to mark an harvest 'Received'
    // Use the above modifiers to check if the harvest is shipped
    function deliver(uint _shipmentId) public
        shipmentExists(_shipmentId)
        onlyBuyer()
        hasPermission(RECIEVER_OF_ROLE, msg.sender, bytes32(_shipmentId) ,"Missing RECIEVER_OF_ROLE") payable
    {

        Shipment storage shipment_ = shipments[_shipmentId];
        require(shipment_.delivered == false, ERROR_ALREADY_DELIVERED);

        shipment_.delivered = true;
        shipment_.dateDelivered = now;

        Harvest storage harvest_ = harvests[shipment_.upc];
        Quote storage quote_ = quotes[shipment_.quoteId];

        //Pay shipping balance

        if(quote_.shippingDownPayment > quote_.shippingCost) {
            quote_.shipperId.transfer(quote_.shippingCost - quote_.shippingDownPayment);
        }

        harvest_.harvesterId.transfer(quote_.price);


        uint256 balanceCost = quote_.price + quote_.shippingCost - quote_.shippingDownPayment;
        if(msg.value > balanceCost) {
            msg.sender.transfer(msg.value - balanceCost);
        }

        emit Delivered(_shipmentId);
    }



    function fetchDownpayment(uint _quoteId) public view returns
    (
    uint    downPayment
    )
    {
        Quote storage quote_ = quotes[_quoteId];
        downPayment = quote_.shippingDownPayment;
    }

    function fetchDeliveryBalance(uint _quoteId) public view returns
    (
    uint    balance
    )
    {
        Quote storage quote_ = quotes[_quoteId];
        balance = quote_.price + quote_.shippingCost - quote_.shippingDownPayment;
    }



    fetchHarvestXsku(uint _sku) public view verifyHarvest_has_sku(_sku) returns
    (
        uint upc;
        address harvesterId;
        address originBeekeeperId;
        string originBeekeeperName;
        string originFarmInformation;
        string originFarmLatitude;
        string originFarmLongitude;
        uint quantity;
        uint productId;
        string productNotes;
        uint productPrice;
        address shipperId;
        address buyerId;
    )
    {
        Harvest storage harvest_ = HarvestXsku[_sku];
        upc = harvest_.upc;
        harvesterId = harvest_.harvesterId;
        originBeekeeperId = harvest_.originBeekeeperId;
        originBeekeeperName = harvest_.originBeekeeperName;
        originFarmInformation = harvest_.originFarmInformation;
        originFarmLatitude = harvest_.originFarmLatitude;
        originFarmLongitude = harvest_.originFarmLongitude;
        quantity = harvest_.quantity;
        productId = harvest_.productId;
        productNotes = harvest_.productNotes;
        productPrice = harvest_.productPrice;
        shipperId = harvest_.shipperId;
        buyerId = harvest_.buyerId;
    }

    fetchOrderXorderId(uint _orderId) public view verifyOrder_has_orderId(_orderId) returns
    (
        address buyerId;
        uint upc;
        uint quantity;
    )
    {
        Order storage order_ = OrderXorderId[_orderId];
        buyerId = order_.buyerId;
        upc = order_.upc;
        quantity = order_.quantity;
    }

    fetchQuoteXquoteId(uint _quoteId) public view verifyQuote_has_quoteId(_quoteId) returns
    (
        uint orderId;
        uint upc;
        uint price;
        address shipperId;
        uint shippingCost;
        uint shippingDownPayment;
        uint date;
    )
    {
        Quote storage quote_ = QuoteXquoteId[_quoteId];
        orderId = quote_.orderId;
        upc = quote_.upc;
        price = quote_.price;
        shipperId = quote_.shipperId;
        shippingCost = quote_.shippingCost;
        shippingDownPayment = quote_.shippingDownPayment;
        date = quote_.date;
    }

    fetchPurchaseXpurchaseId(uint _purchaseId) public view verifyPurchase_has_purchaseId(_purchaseId) returns
    (
        uint quoteId;
        uint orderId;
        uint upc;
        uint shipmentId;
        uint date;
    )
    {
        Purchase storage purchase_ = PurchaseXpurchaseId[_purchaseId];
        quoteId = purchase_.quoteId;
        orderId = purchase_.orderId;
        upc = purchase_.upc;
        shipmentId = purchase_.shipmentId;
        date = purchase_.date;
    }

    fetchShipmentXshipmentId(uint _shipmentId) public view verifyShipment_has_shipmentId(_shipmentId) returns
    (
        address shipper;
        uint purchaseId;
        uint quoteId;
        uint orderId;
        uint upc;
        uint date;
        bool delivered;
        uint dateDelivered;
    )
    {
        Shipment storage shipment_ = ShipmentXshipmentId[_shipmentId];
        shipper = shipment_.shipper;
        purchaseId = shipment_.purchaseId;
        quoteId = shipment_.quoteId;
        orderId = shipment_.orderId;
        upc = shipment_.upc;
        date = shipment_.date;
        delivered = shipment_.delivered;
        dateDelivered = shipment_.dateDelivered;
    }

    fetchDeliveryXdeliveryId(uint _deliveryId) public view verifyDelivery_has_deliveryId(_deliveryId) returns
    (
        uint shipmentId;
        uint purchaseId;
        uint quoteId;
        uint orderId;
        uint upc;
        uint date;
    )
    {
        Delivery storage delivery_ = DeliveryXdeliveryId[_deliveryId];
        shipmentId = delivery_.shipmentId;
        purchaseId = delivery_.purchaseId;
        quoteId = delivery_.quoteId;
        orderId = delivery_.orderId;
        upc = delivery_.upc;
        date = delivery_.date;
    }



    fetchHarvestXupc(uint _upc) public view verifyHarvest_has_upc(_upc) returns
    (
        uint sku;
        address harvesterId;
        address originBeekeeperId;
        string originBeekeeperName;
        string originFarmInformation;
        string originFarmLatitude;
        string originFarmLongitude;
        uint quantity;
        uint productId;
        string productNotes;
        uint productPrice;
        address shipperId;
        address buyerId;
    )
    {
        Harvest storage harvest_ = HarvestXupc[_upc];
        sku = harvest_.sku;
        harvesterId = harvest_.harvesterId;
        originBeekeeperId = harvest_.originBeekeeperId;
        originBeekeeperName = harvest_.originBeekeeperName;
        originFarmInformation = harvest_.originFarmInformation;
        originFarmLatitude = harvest_.originFarmLatitude;
        originFarmLongitude = harvest_.originFarmLongitude;
        quantity = harvest_.quantity;
        productId = harvest_.productId;
        productNotes = harvest_.productNotes;
        productPrice = harvest_.productPrice;
        shipperId = harvest_.shipperId;
        buyerId = harvest_.buyerId;
    }

    fetchOrderXupc(uint _upc) public view verifyOrder_has_upc(_upc) returns
    (
        uint orderId;
        address buyerId;
        uint quantity;
    )
    {
        Order storage order_ = OrderXupc[_upc];
        orderId = order_.orderId;
        buyerId = order_.buyerId;
        quantity = order_.quantity;
    }

    fetchQuoteXorderId(uint _orderId) public view verifyQuote_has_orderId(_orderId) returns
    (
        uint quoteId;
        uint upc;
        uint price;
        address shipperId;
        uint shippingCost;
        uint shippingDownPayment;
        uint date;
    )
    {
        Quote storage quote_ = QuoteXorderId[_orderId];
        quoteId = quote_.quoteId;
        upc = quote_.upc;
        price = quote_.price;
        shipperId = quote_.shipperId;
        shippingCost = quote_.shippingCost;
        shippingDownPayment = quote_.shippingDownPayment;
        date = quote_.date;
    }

    fetchPurchaseXquoteId(uint _quoteId) public view verifyPurchase_has_quoteId(_quoteId) returns
    (
        uint purchaseId;
        uint orderId;
        uint upc;
        uint shipmentId;
        uint date;
    )
    {
        Purchase storage purchase_ = PurchaseXquoteId[_quoteId];
        purchaseId = purchase_.purchaseId;
        orderId = purchase_.orderId;
        upc = purchase_.upc;
        shipmentId = purchase_.shipmentId;
        date = purchase_.date;
    }

    fetchShipmentXpurchaseId(uint _purchaseId) public view verifyShipment_has_purchaseId(_purchaseId) returns
    (
        uint shipmentId;
        address shipper;
        uint quoteId;
        uint orderId;
        uint upc;
        uint date;
        bool delivered;
        uint dateDelivered;
    )
    {
        Shipment storage shipment_ = ShipmentXpurchaseId[_purchaseId];
        shipmentId = shipment_.shipmentId;
        shipper = shipment_.shipper;
        quoteId = shipment_.quoteId;
        orderId = shipment_.orderId;
        upc = shipment_.upc;
        date = shipment_.date;
        delivered = shipment_.delivered;
        dateDelivered = shipment_.dateDelivered;
    }

    fetchDeliveryXshipmentId(uint _shipmentId) public view verifyDelivery_has_shipmentId(_shipmentId) returns
    (
        uint deliveryId;
        uint purchaseId;
        uint quoteId;
        uint orderId;
        uint upc;
        uint date;
    )
    {
        Delivery storage delivery_ = DeliveryXshipmentId[_shipmentId];
        deliveryId = delivery_.deliveryId;
        purchaseId = delivery_.purchaseId;
        quoteId = delivery_.quoteId;
        orderId = delivery_.orderId;
        upc = delivery_.upc;
        date = delivery_.date;
    }


}