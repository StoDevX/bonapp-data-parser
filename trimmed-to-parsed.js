#!/usr/bin/env node
'use strict'

const peg = require('./bonapp')
const glob = require('glob')
const fs = require('fs')
const path = require('path')

for (let f of glob.sync('./data-trimmed/*.txt')) {
	let c = fs.readFileSync(f, 'utf-8')
	let fn = path.basename(f, '.txt')
	try {
		let res = peg.parse(c)
		fs.writeFileSync('./data-parsed/' + fn + '.json', JSON.stringify(res, null, 2))
	} catch(err) {
		console.log(f)
		console.log(c)
		console.error(err)
		break
	}
}
