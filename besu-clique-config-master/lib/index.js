const yargs = require('yargs');
const {mkdir, readFile, writeFile} = require('fs');
const {promisify} = require('util');
const {createECDH} = require('crypto');
const {publicToAddress, privateToPublic} = require('ethereumjs-util');

const mkdirAsync = promisify(mkdir);
const readFileAsync = promisify(readFile);
const writeFileAsync = promisify(writeFile);

const {argv} = yargs
  .usage('Usage: $0 --config-file=[string] --to=[string] --private-key-file-name=[string]')
  .demandOption(['configFile', 'to', 'privateKeyFileName']);

const {configFile, to, privateKeyFileName} = argv;
let _nodes = [];

const execute = async () => {
  const config = await loadConfig();

  setupNodes(config.blockchain.nodes.count);
  await mkdirAsync(`${process.cwd()}/${to}`);
  await Promise.all(_nodes.map(saveKeyPair))
  await saveGenesisFile(config.genesis);
}

const setupNodes = count => {
  _nodes = Array.from(new Array(count), () => generateKeyPair())
}

const generateKeyPair = () => {
  const ecdh = createECDH('secp256k1');
  ecdh.generateKeys();

  const privKey = prefix(ecdh.getPrivateKey('hex', 'compressed'));
  const pubKey = privateToPublic(privKey);

  return {
    privKey, 
    pubKey: pubKey.toString('hex'),
    nodeAddress: publicToAddress(pubKey).toString('hex')
  }
}

const prefix = key => `0x${key}`;

const loadConfig = async () => {
  const config = await readFileAsync(configFile, 'utf8');
  return JSON.parse(config);
}

const createFileContent = data => new Uint8Array(Buffer.from(data));

const getNodeDir = nodeAddress => `${process.cwd()}/${to}/${prefix(nodeAddress)}`

const saveKeyPair = async ({privKey, pubKey, nodeAddress}) => {
  const nodeDir = getNodeDir(nodeAddress);

  await mkdirAsync(nodeDir);
  await writeFileAsync(`${nodeDir}/${privateKeyFileName}`, createFileContent(privKey));
  await writeFileAsync(`${nodeDir}/key.pub`, createFileContent(prefix(pubKey)));
}

const saveGenesisFile = async genesis => {
  genesis.extraData = genesis.extraData.replace('<signers>', getSignerAddresses());
  await writeFileAsync(`${process.cwd()}/${to}/genesis.json`, JSON.stringify(genesis, null, 2));
}

const getSignerAddresses = () => _nodes.map(n => n.nodeAddress).join('');

module.exports = {execute}
