import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CodemirrorModule } from '@ctrl/ngx-codemirror';

import { AppComponent } from './app.component';
import { EditorComponent } from './editor/editor.component';
import { ConsoleComponent } from './console/console.component';
import { ShowgraphComponent } from './showgraph/showgraph.component';

@NgModule({
  declarations: [
    AppComponent,
    EditorComponent,
    ConsoleComponent,
    ShowgraphComponent,
  ],
  imports: [BrowserModule, FormsModule, CodemirrorModule],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
