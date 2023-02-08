import panzoom from "panzoom"
import LeaderLine from "leader-line-new"

let select-origin = null
let select-target = null
let mx = 0
let my = 0

class Node
	constructor type\string
		type = type
		deps = []

tag compose-node
	css d:block pos:relative p:3 m:1
		bg:white bxs:sm rd:sm cursor:default
		@touch scale:1.02
		@move scale:1.05 rotate:2deg zi:2 bxs:lg
	prop node
	def build
		x = y = 0
		arrow-from = null
		arrow-temp = null
	<self[x:{x} y:{y} s:fit-content]> 
		<div$mpos[pos:fixed w:0 h:0 x:{mx} y:{my}]>
		switch node.node.type
			when "Output" then <div[d:flex fld:row]>
				<div$in_o[rotate:-90deg bd:dotted]
					@dragover.prevent
					@drop=(arrow-from = new LeaderLine(select-origin, $in_o))> "in"
				<div @touch.moved.sync(self)> "Output"
			when "Code" then <div[d:flex fld:row]>
				<div$in_c[rotate:-90deg bd:dotted]
					@dragover.prevent
					@drop=(arrow-from = new LeaderLine(select-origin, $in_c))> "in"
				<div @touch.moved.sync(self)>
					<textarea>
				<div$out[rotate:90deg bd:dotted]
					html:draggable="true"
					@dragstart=(select-origin=$out; arrow-temp = new LeaderLine(select-origin, $mpos))
					@dragend=(arrow-temp.remove(); arrow-temp = null)
					@drag=(do mx=$1.x; my=$1.y; arrow-temp.position())
					> "out"
			else "Node"		

tag app
	prop nodes
	prop out
	<self> <div$canvas[w:100vw h:100vh]
		@click.shift=(nodes.add(new Node("Code")))> for node of nodes
		<compose-node node={node}>

const out = new Node("Output")
const nodes = new Set([out])
imba.mount do <app out=out nodes=nodes>
