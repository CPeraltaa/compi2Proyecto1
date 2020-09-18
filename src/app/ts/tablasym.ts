import { TipoDato } from './../abstract/tipo';

export class TablaSimbolos {
  simbolos: Map<string, Simbolo>;

  constructor(symbols: Map<string, Simbolo>) {
    this.simbolos = symbols;
  }

  addSymbol(symbol: Simbolo): void {
    this.simbolos.set(symbol.id, symbol);
  }

  getSymbol(id: string): Simbolo {
    if (!this.simbolos.has(id)) {
      return null;
    }
    return this.simbolos.get(id);
  }

  updateSymbol(symbol: Simbolo): void {
    this.simbolos.set(symbol.id, symbol);
  }

  getReportTS(): Map<string, Simbolo> {
    return this.simbolos;
  }

  clearTS(): void {
    this.simbolos.clear();
  }
}

export class Simbolo {
  id: string;
  tipo: TipoDato;
  valor: any;
  ambito: string;

  constructor(id: string, tipo: TipoDato) {
    this.id = id;
    this.tipo = tipo;
    this.valor = null;
    this.ambito = 'Global';
  }

  updateValor(valor: any) {
    this.valor = valor;
  }

  updateTipo(tipo: TipoDato) {
    this.tipo = tipo;
  }

  updateTipovalor(valor: any, tipo: TipoDato) {
    this.valor = valor;
    this.tipo = tipo;
  }
}
