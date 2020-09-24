export class NodoArbol {
  etiqueta: string;
  idnodo: number;
  instruccion: any;
  hijos: NodoArbol[];
  constructor(etiqueta: string, idnodo: number, instr: any) {
    this.etiqueta = etiqueta;
    this.idnodo = idnodo;
    this.instruccion = instr;
    this.hijos = [];
  }

  addNodo(hijo: NodoArbol): void {
    this.hijos.push(hijo);
  }

  clearHijos(): void {
    this.hijos = [];
  }
}

export class DrawArbol {
  raiz: NodoArbol;
  cuerpo: string;
  cuerpoaux: string;

  constructor(raiz: NodoArbol) {
    this.raiz = raiz;
    this.cuerpo = '';
    this.cuerpoaux = '';
  }

  createCuerpo(raiz: NodoArbol): void {
    if (raiz != null) {
      this.cuerpo +=
        raiz.idnodo.toString() + ' [label="' + raiz.etiqueta + '"];\n';
      for (let hijo of raiz.hijos) {
        this.createCuerpo(hijo);
        this.cuerpoaux += raiz.idnodo.toString() + '->' + hijo.idnodo + ';\n';
      }
    }
  }

  createArbol(): void {
    this.createCuerpo(this.raiz);
    let printCuerpo =
      'digraph arbolAST{\n' + this.cuerpo + this.cuerpoaux + '}\n';
    //call d3.graphviz command
  }
}
