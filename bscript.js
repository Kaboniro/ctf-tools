#!/usr/bin/env node

const fs = require('fs');
const bcrypt = require('bcrypt');

function readFile(filepath) {
  try {
    const data = fs.readFileSync(filepath, 'utf-8');
    return data.split('\n').map(word => word.trim());
  } catch (error) {
    console.error(`Error reading file: ${error.message}`);
    return [];
  }
}

async function findWord(wordlist, hash) {
  for (const word of wordlist) {
    const match = await bcrypt.compare(word, hash);
    if (match) {
      return word;
    }
  }
  return null;
}

async function main() {
  let hash = process.argv[2];
  let wordlistPath = process.argv[3];

  if (!wordlistPath || wordlistPath.trim() === '') {
    console.log("Wordlist path is empty");
    return;
  }

  let wordlist = readFile(wordlistPath);

  if (wordlist.length === 0) {
    console.log("Wordlist is empty or file not found.");
    return;
  }

  let result = await findWord(wordlist, hash);
  if (result) {
    console.log(`Found match: ${result}`);
  } else {
    console.log("No match found");
  }
}

main();
