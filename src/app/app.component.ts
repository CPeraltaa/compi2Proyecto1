import { EditorComponent } from './editor/editor.component';
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  title = 'proyecto-compi';
  showFirst: boolean = true;

  toggle(): void {
    this.showFirst = !this.showFirst;
  }
}
