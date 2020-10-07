import { DrawArbol } from './../ast/ast';
import { wasmFolder } from '@hpcc-js/wasm';
import { graphviz } from 'd3-graphviz';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-showgraph',
  templateUrl: './showgraph.component.html',
  styleUrls: ['./showgraph.component.css'],
})
export class ShowgraphComponent implements OnInit {
  constructor(private arbolito: DrawArbol) {}

  ngOnInit(): void {
    wasmFolder('/assets/@hpcc-js/wasm/dist/');
    graphviz('#graph').renderDot(this.arbolito.returnAST());
  }
}
