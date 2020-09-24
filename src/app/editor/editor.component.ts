import { Component, OnInit } from '@angular/core';
import Parser from '../grammar/grammar';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.css'],
})
export class EditorComponent implements OnInit {
  entrada = '';
  salida = '';

  options: any = {
    lineNumbers: true,
    theme: 'twilight',
    lineWrapping: true,
    indentWithTabs: true,
    mode: 'javascript',
    styleActiveLine: true,
  };

  constructor() {}

  ngOnInit(): void {}

  ejecutar() {
    try {
      const value = Parser.parse(this.entrada);
      this.salida = value + '';
    } catch (error) {
      alert('Aun no valido errores ' + error.toString());
    }
  }
}
