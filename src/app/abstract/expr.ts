import { Nodo } from './../interfaces/nodo';
import { TipoDato } from './tipo';

export abstract class Expresion implements Nodo {
  linea: number;
  columna: number;
  constructor(lin: number, col: number) {
    this.linea = lin;
    this.columna = col;
  }

  getColumna(): number {
    return this.columna;
  }
  getLinea(): number {
    return this.linea;
  }
  abstract getValor(): any;

  abstract getTipo(): TipoDato;
}
