// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract ResolverV2 {
address public owner;

mapping(string => address) private nameToAddress;
mapping(address => string[]) private addressToNames;
mapping(string => bool) public allowedSuffixes;
mapping(string => bool) private revokedNames;
mapping(address => bool) public approvers;
mapping(string => uint256) public nameTimestamps;
mapping(address => string[]) public pendingRequests;

event NameRequested(address indexed user, string name);
event NameRegistered(address indexed user, string name);
event NameRevoked(string name);
event NameTransferred(string name, address from, address to);
event ApproverAdded(address approver);
event ApproverRemoved(address approver);

modifier onlyOwner() {
require(msg.sender == owner, "Not contract owner");
_;
}

modifier onlyApprover() {
require(approvers[msg.sender], "Not approved admin");
_;
}

constructor() {
owner = msg.sender;
approvers[msg.sender] = true;

// STATES (50)
string[50] memory stateSuffixes = [
"alabama", "alaska", "arizona", "arkansas", "california", "colorado", "connecticut",
"delaware", "florida", "georgia", "hawaii", "idaho", "illinois", "indiana", "iowa",
"kansas", "kentucky", "louisiana", "maine", "maryland", "massachusetts", "michigan",
"minnesota", "mississippi", "missouri", "montana", "nebraska", "nevada", "newhampshire",
"newjersey", "newmexico", "newyork", "northcarolina", "northdakota", "ohio", "oklahoma",
"oregon", "pennsylvania", "rhodeisland", "southcarolina", "southdakota", "tennessee",
"texas", "utah", "vermont", "virginia", "washington", "westvirginia", "wisconsin", "wyoming"
];
for (uint i = 0; i < stateSuffixes.length; i++) {
allowedSuffixes[stateSuffixes[i]] = true;
}

// CAPITALS (50)
string[50] memory capitalSuffixes = [
"montgomery", "juneau", "phoenix", "littlerock", "sacramento", "denver", "hartford",
"dover", "tallahassee", "atlanta", "honolulu", "boise", "springfield", "indianapolis",
"desmoines", "topeka", "frankfort", "batonrouge", "augusta", "annapolis", "boston",
"lansing", "saintpaul", "jackson", "jeffersoncity", "helena", "lincoln", "carsoncity",
"concord", "trenton", "santafe", "albany", "raleigh", "bismarck", "columbus", "oklahomacity",
"salem", "harrisburg", "providence", "columbia", "pierre", "nashville", "austin",
"saltlakecity", "montpelier", "richmond", "olympia", "charleston", "madison", "cheyenne"
];
for (uint i = 0; i < capitalSuffixes.length; i++) {
allowedSuffixes[capitalSuffixes[i]] = true;
} //

// MAJOR CITIES (150)
string[150] memory citySuffixes = [
"birmingham","greensboro","spokecane","bakersfield", "mobile", "huntsville", "anchorage", "fairbanks", "ketchikan",
"fayetteville", "fortsmith", "littlerock", "sanfrancisco", "fresno", "sacramento",
"coloradosprings", "boulder", "fortcollins", "newhaven", "stamford", "hartford",
"wilmington", "dover", "newarkde", "jacksonville", "tallahassee", "fortlauderdale",
"hilo", "kahului", "kapolei", "idahofalls", "coeurdalene", "twinfalls",
"peoria", "springfieldil", "rockford", "evansville", "fortwayne", "southbend",
"cedarrapids", "davenport", "ames", "wichita", "overlandpark", "lawrence",
"lexington", "louisville", "bowlinggreen", "portlandme", "lewiston", "bangor",
"kalamazoo", "annarbormi", "saginaw", "biloxi", "hattiesburg", "gulfport",
"stlouis", "kansascity", "springfieldmo", "billings", "missoula", "bozeman",
"omaha", "lincoln", "bellevue", "elko", "northlasvegas", "carsoncity",
"manchester", "nashuanh", "portsmouthnh", "newark", "jerseycity", "paterson",
"albuquerque", "roswell", "lascruces", "syracuse", "yonkers", "whiteplains",
"durham", "fayettevillenc", "wilmingtonnc", "fargo", "minot", "grandforks",
"toledo", "akron", "dayton", "tulsa", "norman", "brokenarrow",
"portlandor", "eugene", "bend", "warwick", "cranston", "newport",
"charleston", "greenville", "myrtlebeach", "siouxfalls", "rapidcity", "aberdeen",
"sanantonio", "fortworth", "elpaso", "ogden", "provo", "stgeorge",
"burlington", "montpelier", "rutland", "virginiabeach", "norfolk", "roanokeva",
"bellevue", "everett", "yakima", "morgantown", "huntington", "wheeling",
"milwaukee", "greenbay", "kenosha", "casper", "gillette", "laramie",
"palmsprings", "santabarbara", "redding", "lubbock", "amarillo", "roundrock",
"clearwater", "capecanaveral", "pensacola", "erie", "scranton", "bethlehem",
"longisland", "utica", "cedarfalls", "watertown", "evanston", "lynchburg",
"fredericksburg", "portangeles", "bellingham"
];
for (uint i = 0; i < citySuffixes.length; i++) {
allowedSuffixes[citySuffixes[i]] = true;
}

// BRANDS (8)
string[11] memory brandSuffixes = [
"grownfolk", "thomas", "wilder", "miner", "uclickweship", "youngfolk", "gfu", "yfi", "us", "weship", "ucws"
];
for (uint i = 0; i < brandSuffixes.length; i++) {
allowedSuffixes[brandSuffixes[i]] = true;
} 

} //

function addApprover(address _approver) external onlyOwner {
approvers[_approver] = true;
emit ApproverAdded(_approver);
}

function removeApprover(address _approver) external onlyOwner {
approvers[_approver] = false;
emit ApproverRemoved(_approver);
}

function isApprover(address user) external view returns (bool) {
return approvers[user];
}

function requestName(string calldata name) external {
require(bytes(name).length > 0, "Name required");
string memory suffix = getSuffix(name);
require(allowedSuffixes[suffix], "Invalid suffix");
require(nameToAddress[name] == address(0), "Name taken");
require(!revokedNames[name], "Name revoked");
require(containsDot(name), "Name must include suffix");

pendingRequests[msg.sender].push(name);
emit NameRequested(msg.sender, name);
}

function approveAndRegister(address user, string calldata name) external onlyApprover {
require(bytes(name).length > 0, "Name required");
require(nameToAddress[name] == address(0), "Name taken");
require(!revokedNames[name], "Name revoked");

string memory suffix = getSuffix(name);
require(allowedSuffixes[suffix], "Invalid suffix");

nameToAddress[name] = user;
addressToNames[user].push(name);
nameTimestamps[name] = block.timestamp;

emit NameRegistered(user, name);
}

function revokeName(string calldata name) external onlyApprover {
require(nameToAddress[name] != address(0), "Name not registered");
revokedNames[name] = true;
emit NameRevoked(name);
}

function transferName(string calldata name, address to) external onlyApprover {
require(nameToAddress[name] != address(0), "Not registered");
require(!revokedNames[name], "Name is revoked");

address oldOwner = nameToAddress[name];
nameToAddress[name] = to;
addressToNames[to].push(name);

emit NameTransferred(name, oldOwner, to);
}

function addSuffix(string calldata suffix) external onlyOwner {
allowedSuffixes[suffix] = true;
}

function isRevoked(string calldata name) external view returns (bool) {
return revokedNames[name];
}

function getAddress(string calldata name) external view returns (address) {
return nameToAddress[name];
}

function getNames(address wallet) external view returns (string[] memory) {
return addressToNames[wallet];
}

function getPending(address wallet) external view returns (string[] memory) {
return pendingRequests[wallet];
}

function getSuffix(string memory fullName) internal pure returns (string memory) {
bytes memory strBytes = bytes(fullName);
for (uint i = strBytes.length; i > 0; i--) {
if (strBytes[i - 1] == bytes1(".")) {
return substring(fullName, i, strBytes.length);
}
}
return fullName;
}

function containsDot(string memory str) internal pure returns (bool) {
bytes memory b = bytes(str);
for (uint i = 0; i < b.length; i++) {
if (b[i] == bytes1(".")) return true;
}
return false;
}

function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
bytes memory strBytes = bytes(str);
bytes memory result = new bytes(endIndex - startIndex);
for (uint i = startIndex; i < endIndex; i++) {
result[i - startIndex] = strBytes[i];
}
return string(result);
}
}