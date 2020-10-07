



/*Segmento de codigo*/
%{
    const {NodoArbol, DrawArbol} = require('../ast/ast');

    var id = 0;
    var raiz = new NodoArbol("s", -1, null);

    function inc(){
        id++;
        return id;
    }

    function parseAST(entrada){
        this.parse(entrada);
        var grafica = new DrawArbol(raiz);
        grafica.createArbol();
    }

    exports.parseAST = parseAST;
%}



/* Direcciones lexical de la gramatica */
%lex
%options flex case-sensitive 
%option yylineno 
%locations 
%%

/*
"\""([^\n\"\\]*(\\[.\n])*)*"\""  
*/

\s+                                   /* IGNORE */
"//".*                                /* IGNORE */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */
([0-9])+"."([0-9])*                 return 'Decimal';
[0-9]+("."[0-9]+)?\b                return 'Number';
\"([^\\\"]|\\.)*\"                  return 'Cadena1';
\'([^\\\"]|\\.)*\'                  return 'Cadena2';

"*"                                 return 'tPor';
"/"                                 return 'tDivision';
"-"                                 return 'tMenos';
"+"                                 return 'tMas';
"("                                 return 'tPara';
")"                                 return 'tParc';
"^"                                 return 'tXor';
"||"                                return 'tOr';
"&&"                                return 'tAnd';
"!"                                 return 'tNot';
"++"                                return 'tMasm';
"--"                                return 'tMenosm';
","                                 return 'tComa';
"."                                 return 'tPunto';
";"                                 return 'tPtcoma';
":"                                 return 'tDosPts';
"["                                 return 'tCorizq';
"]"                                 return 'tCorder';
"{"                                 return 'tLlavea';
"}"                                 return 'tLlavec';
"="                                 return 'tIgual';
"=="                                return 'tIguaIg';
"!="                                return 'tNoIgu';
"?"                                 return 'tTern';

">"                                 return 'tMayor';
"<"                                 return 'tMenor';
">="                                return 'tMayoI';
"<="                                return 'tMenoI';



"function"                          return  'tfunction';
"break"                             return  'tbreak';
"continue"                          return  'tcontinue';
"return"                            return  'treturn';
"if"                                return  'tif';
"switch"                            return  'tswitch';
"default"                           return  'tdefault';
"else"                              return  'telse';
"case"                              return  'tcase';
"while"                             return  'twhile';
"do"                                return  'tdo';
"for"                               return  'tfor';
"in"                                return  'tin';
"let"                               return  'tlet';
"const"                             return  'tconst';
"pop"                               return  'tpop';
"push"                              return  'tpush';
"lenght"                            return  'tlenght';
"type"                              return  'ttype';
"void"                              return  'tVoid';
"boolean:"                          return  'tBoolean:';
"number"                            return  'tNumber';
"string"                            return  'tString';
"Array"                             return  'tArray';
"in"                                return  'tin';
"of"                                return  'tof';
"null"                              return  'tnull';
"true"                              return  'ttrue';
"false"                             return  'tfalse';




[a-zA-Z_][_a-zA-Z0-9ñÑ]*            return 'Identificador';


// EOF means "end of file"
<<EOF>>               return 'EOF'
// any other characters will throw an error
.                     return 'INVALID'

/lex

// Operator associations and precedence.
//
// This is the part that defines rules like
// e.g. multiplication/division apply before
// subtraction/addition, etc. Of course you can
// also be explicit by adding parentheses, as
// we all learned in elementary school.
//
// Notice that there's this weird UMINUS thing.
// This is a special Bison/Jison trick for preferring
// the unary interpretation of the minus sign, e.g.
// -2^2 should be interpreted as (-2)^2 and not -(2^2).
//
// Details here:
// http://web.mit.edu/gnu/doc/html/bison_8.html#SEC76

%left tMas 
%left tMenos
%left tPor 
%left tDivision
%left tAnd 
%left tXor
%left tOr 
%left tNot
%left tMayor 
%left tMenor 
%left tMayoI 
%left tMenoI
%left tIguaIg
%left tNoIgu
%left tTern
%left UMINUS




%start S

%% /* language grammar */

// At the top level, you explicitly return
// the result. $1 refers to the first child node,
// i.e. the "e"

S:                      INICIO EOF{
                            raiz.addNodo($1);
                        }
                        ;

INICIO:                 LINSTRUCCIONES{
                            $$ = $1;
                        }
                        ;


LINSTRUCCIONES:         LINSTRUCCIONES INSTRUCCIONES{
                            id = inc();
                            var temp = new NodoArbol("ListInstrucciones", id, null);
                            temp.addNodo($1);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | INSTRUCCIONES{
                            $$ = $1;
                        }
                        ;

INSTRUCCIONES:          FUNCION{
                            $$ = $1;
                        }
                        | DEC_VARIABLE{
                            $$ = $1;
                        }
                        | logi tPtcoma
                        | TYPESTRUCT
                        | ACCSATRI tPtcoma  
                        ;

 


FUNCION:                tfunction Identificador tPara LPRAMFUNC tParc tLlavea BODYFUN tLlavec
                        | tfunction Identificador tPara LPRAMFUNC tParc tDosPts TYPEFUNCION tLlavea BODYFUN tLlavec
                        | tfunction Identificador tPara tParc tLlavea BODYFUN tLlavec
                        | tfunction Identificador tPara tParc tDosPts TYPEFUNCION tLlavea BODYFUN tLlavec
                        ;



//tipos de funciones con Identificador inlcuido revisar 

TYPEFUNCION:             TYPEVAR{
                            $$ = $1;
                        }
                        | tVoid{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Identificador{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        ;


TYPEVAR:                tBoolean{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            $$ = temp;
                        }
                        | tNumber{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            $$ = temp;
                        }
                        | tString{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            $$ = temp;
                        }
                        | tnull{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            $$ = temp;
                        }
                        ;

//Estructuras TYPE
TYPESTRUCT:         ttype Identificador tIgual tLlavea LISTAVAR tLlavec tPtcoma
                    ;

LISTAVAR:           LISTAVAR tComa Identificador tDosPts LISTYPE{
                        id = inc();
                        var temp = new NodoArbol("ListaVar", id, null);
                        id = inc();
                        var temp2 = new NodoArbol($3.toString(), id, null);
                        $5.addNodo(temp2);
                        temp.addNodo($1);
                        temp.addNodo($5);
                    }
                    | Identificador tDosPts LISTYPE{
                        id = inc();
                        $3.addNodo(new NodoArbol($1.toString(), id, null));
                        $$ = $3;
                    }
                    ;




LISTYPE:        TYPEVAR{
                    $$ = $1;
                }
                | Identificador{
                    id = inc();
                    $$ = new NodoArbol($1.toString(), id, null);
                }
                ;

//PARAMETROS DE FUNCION

LPRAMFUNC:              LPRAMFUNC tComa PARAMFUNCION{
                            id = inc();
                            var temp = new NodoArbol("ListParam", id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | PARAMFUNCION{
                            $$ = $1;
                        }
                        ;

PARAMFUNCION:           Identificador tDosPts TYPEVAR tIgual logi{
                            id = inc();
                            var temp = new NodoArbol($4.toString(), id, null);
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo($3);
                            temp.addNodo($5);
                            $$ = temp;
                        }
                        | Identificador tTern tDosPts TYPEVAR{
                            id = inc();                      
                            $4.addNodo(new NodoArbol($1.toString() + "?", id, null));
                            $$ = $4;
                        }
                        | Identificador tDosPts TYPEVAR{
                            id = inc();                      
                            $3.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = $3;
                        }
                        | Identificador tDosPts Identificador tIgual logi{
                            id = inc();
                            var temp = new NodoArbol($4.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo(temp2);
                            temp.addNodo($5);
                            $$ = temp;
                        }
                        | Identificador tTern tDosPts Identificador{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();                         
                            temp.addNodo(new NodoArbol($1.toString() + "?", id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts Identificador{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();                         
                            temp.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR LISTACOR{
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = $3;
                        }
                        | Identificador tDosPts Identificador LISTACOR{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = temp;
                        }
                        ;



//DECLARACION DE VARIABLES 


LISTDECID:              LISTDECID  tComa TIPODEDECL{
                            id = inc();
                            var temp = new NodoArbol("ListID", id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | TIPODEDECL{
                            $$ = $1;
                        }
                        ;

TIPODEDECL:             Identificador{
                            id = inc();
                            var temp = new NodoArbol("Any", id, null);
                            id = inc();
                            temp.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = temp;                   
                        }
                        | Identificador tDosPts TYPEVAR{                                                      
                            id = inc();                      
                            $3.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = $3;
                        }
                        | Identificador tDosPts Identificador{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();                         
                            temp.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR tIgual  VARIGUA{
                            id = inc();
                            var temp = new NodoArbol($4.toString(), id, null);
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo($3);
                            temp.addNodo($5);
                            $$ = temp;
                        }
                        | Identificador tDosPts Identificador tIgual  VARIGUA{
                            id = inc();
                            var temp = new NodoArbol($4.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo(temp2);
                            temp.addNodo($5);
                            $$ = temp;
                        }
                        | Identificador tIgual VARIGUA{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol("Any", id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo(temp2);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | Identificador tDosPts Array tMenor TYPEVAR tMayor{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            $5.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo($5);
                            $$ = temp;
                        }
                        | Identificador tDosPts Array tMenor Identificador tMayor{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($5.toString(), id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($1.toString(), id, null));
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR LISTACOR{
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = $3;
                        }
                        | Identificador tDosPts Identificador LISTACOR{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR LISTACOR tIgual tCorizq tCorder{
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = $3;
                        }
                        | Identificador tDosPts Identificador LISTACOR tIgual tCorizq tCorder{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts Array tMenor TYPEVAR tMayor tIgual tCorizq LISCOND tCorder{
                            id = inc();
                            var temp = new NodoArbol($7.toString(), id, null);
                            id = inc();
                            $5.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            temp.addNodo($5);
                            temp.addNodo($9);
                            $$ = temp;
                        }
                        | Identificador tDosPts Array tMenor Identificador tMayor tIgual tCorizq LISCOND tCorder{
                            id = inc();
                            var temp = new NodoArbol($7.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($5.toString(), id, null);
                            id = inc();
                            temp2.addNodo($1.toString() + "[]", id, null);
                            temp.addNodo(temp2);
                            temp.addNodo($9);
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR LISTACOR tIgual tCorizq LISCOND tCorder{
                            id = inc();
                            var temp = new NodoArbol($5.toString(), id, null);
                            id = inc();
                            $3.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            temp.addNodo($3);
                            temp.addNodo($7);
                            $$ = temp;
                        }
                        | Identificador tDosPts Identificador LISTACOR tIgual tCorizq LISCOND tCorder{
                            id = inc();
                            var temp = new NodoArbol($5.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($1.toString() + "[]", id, null));
                            temp.addNodo(temp2);
                            temp.addNodo($7);
                            $$ = temp;
                        }
                        ;

VARIGUA:    logi{
                $$ = $1;
            }
            | tLlavea LISTAVAR tLlavec{
                $$ = $2;
            }
            ;



DEC_VARIABLE:           tlet LISTDECID tPtcoma{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | tconst Identificador tDosPts TYPEVAR tIgual logi tPtcoma{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($5.toString(), id, null);
                            id = inc();
                            $4.addNodo(new NodoArbol($2.toString(), id, null));
                            temp2.addNodo($4);
                            temp2.addNodo($6);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        | tconst Identificador tIgual logi tPtcoma{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($3.toString(), id, null);
                            id = inc();
                            var temp3 = new NodoArbol("Any", id, null);
                            id = inc();
                            temp3.addNodo(new NodoArbol($2.toString(), id, null));
                            temp2.addNodo(temp3);
                            temp2.addNodo($4);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        ;


//LIST logi
LISCOND:                LISCOND tComa logi{
                            id = inc();
                            var temp = new NodoArbol("ListLogi", id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | logi{
                            $$ = $1;
                        }
                        ;


LISTACOR:               LISTACOR tCorizq tCorder
                        | tCorizq tCorder
                        ;







/* LCPARAM1:               LCPARAML                    
                        | EPSILON                                 
                        ;             
 */



BODYFUN:                BODYFUN INS_FUN{
                            id = inc();
                            var temp = new NodoArbol("ListInsFunc", id, null);
                            temp.addNodo($1);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | INS_FUN{
                            $$ = $1;
                        }                                     
                        ;


INS_FUN:                CNIF_F{
                            $$ = $1;
                        }                 
                        | WHILE_F{
                            $$ = $1;
                        }                                   
                        | SWITCH_F{
                            $$ = $1;
                        }                        
                        | ACCSATRI tPtcoma{
                            $$ = $1;
                        }                                                          
                        | DO_F{
                            $$ = $1;
                        }                                  
                        | FOR_F{
                            $$ = $1;
                        }       
                        | DEC_VARIABLE{
                            $$ = $1;
                        }
                        | ASIG_VARIABLE{
                            $$ = $1;
                        }
                        | logi tPtcoma{
                            $$ = $1;
                        }                           
                        | tReturn logi tPtcoma
                        | tReturn tPtcoma                  
                        | error tPtcoma                                
                        ;


// INICO  SENTENCIA IF
CNIF_F:                 tif tPara logi tParc tLlavea BODYFUN tLlavec ELSEIF_F telse tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            temp.addNodo($8);
                            id = inc();
                            var temp2 = new NodoArbol($9.toString(), id, null);
                            temp2.addNodo($11);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec telse tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            id = inc();
                            var temp2 = new NodoArbol($8.toString(), id, null);
                            temp2.addNodo($10);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }                
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec ELSEIF_F{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            temp.addNodo($8);
                            $$ = temp;
                        }              
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            $$ = temp;
                        }
                        //| tif  error tPtcoma                     
                        ;



ELSEIF_F:               ELSEIF_F EI_F{
                            id = inc();
                            var temp = new NodoArbol("ListElseIf", id, null);
                            temp.addNodo($1);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | EI_F{
                            $$ = $1;
                        }               
                        ;


 EI_F:                  telse tif tPara logi tParc tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol("else if", id, null);
                            temp.addNodo($4);
                            temp.addNodo($7);
                            $$ = temp;
                        }
                        ;    



// INICO  SENTENCIA SWITCH
SWITCH_F:               tswitch tPara logi tParc tLlavea LCASE_F tdefault tDosPts BODYFUN tBreak tPtcoma tLlavec{
                            id = inc();
                            var temp = new NodoArbol("SWITCH", id, null);
                            id = inc();
                            var temp2 = new NodoArbol("DEFAULT", id, null);
                            temp2.addNodo($9);
                            id = inc();
                            temp2.addNodo(new NodoArbol("BREAK", id, null));
                            temp.addNodo($3);
                            temp.addNodo($6);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        | tswitch tPara logi tParc tLlavea LCASE_F tdefault tDosPts BODYFUN  tLlavec{
                            id = inc();
                            var temp = new NodoArbol("SWITCH", id, null);
                            id = inc();
                            var temp2 = new NodoArbol("DEFAULT", id, null);
                            temp2.addNodo($9);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            temp.addNodo(temp2);
                            $$ = temp;
                        }
                        | tswitch tPara logi tParc tLlavea LCASE_F  tLlavec{
                            id = inc();
                            var temp = new NodoArbol("SWITCH", id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            $$ = temp;
                        }
                        ;
    
                  


LCASE_F:                LCASE_F CASE_F{
                            id = inc();
                            var temp = new NodoArbol("ListCase", id, null);
                            temp.addNodo($1);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | CASE_F{
                            $$ = $1;
                        }
                        ;


CASE_F:                 tcase VALOP tDosPts BODYFUN tBreak tPtcoma{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            temp.addNodo($4);
                            id = inc();
                            temp.addNodo(new NodoArbol($5.toString(), id, null));
                            $$ = temp;
                        }
                        | tcase VALOP tDosPts BODYFUN{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            temp.addNodo($4);
                            $$ = temp;
                        }
                        ;

VALOP:                  | Cadena1{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Decimal{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Number{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Cadena2{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        ;

//WHILE 

WHILE_F:                twhile tPara logi tParc tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol("WHILE", id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            $$ = temp;
                        }
                        ;

 
//DO DE UNA FUNCION:                                  
DO_F:                   tdo tLlavea BODYFUN tLlavec twhile tPara logi tParc tPtcoma{
                            id = inc();
                            var temp = new NodoArbol("DO WHILE", id, null);
                            temp.addNodo($3);
                            temp.addNodo($7);
                            $$ = temp;
                        }
                        ;

// FOR DE UNA FUNCION
FOR_F:                  tfor tPara FORCON tParc tLlavea BODYFUN tLlavec{
                            id = inc();
                            var temp = new NodoArbol("FOR", id, null);
                            temp.addNodo($3);
                            temp.addNodo($6);
                            $$ = temp;
                        }
                        ;                        

FORCON:                 tlet Identificador tIgual logi tPtcoma logi tPtcoma logi{
                            id = inc();
                            var temp = new NodoArbol("FOR COND", id, null);
                            id = inc();
                            var temp2 = new NodoArbol("Any", id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($2.toString(), id, null));
                            id = inc();
                            var temp3 = new NodoArbol($3.toString(), id, null);
                            temp3.addNodo(temp2);
                            temp3.addNodo($4);
                            temp.addNodo(temp3);
                            temp.addNodo($6);
                            temp.addNodo($8);
                            $$ = temp;

                        }
                        | tlet Identificador tof Identificador{
                            id = inc();
                            var temp = new NodoArbol("OF", id, null);
                            id = inc();
                            var temp2 = new NodoArbol("Any", id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($2.toString(), id, null));
                            id = inc();
                            var temp3 = new NodoArbol($4.toString(), id, null);
                            temp.addNodo(temp2);
                            temp.addNodo(temp3);
                            $$ = temp;
                        }
                        | tlet Identificador tin Identificador{
                            id = inc();
                            var temp = new NodoArbol("IN", id, null);
                            id = inc();
                            var temp2 = new NodoArbol("Any", id, null);
                            id = inc();
                            temp2.addNodo(new NodoArbol($2.toString(), id, null));
                            id = inc();
                            var temp3 = new NodoArbol($4.toString(), id, null);
                            temp.addNodo(temp2);
                            temp.addNodo(temp3);
                            $$ = temp;
                        }
                        ;



           

                     


/***********************************PENDIENTE****************************/


// Asignacion variables
ACCSATRI:               CALLLlist tIgual logi                                                                                       
                        ;

/******************************************************/







//logi
 
    logi :              logi tAnd logi{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | logi tOr logi{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | tNot logi{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | condExpression{
                            $$ = $1;
                        }
                        ;
                  
  

    condExpression :    condExpression tMayor sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | condExpression tMenor sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }              
                        | condExpression tMayoI sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }            
                        | condExpression tMenoI  sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | condExpression tIguaIg sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | condExpression tNoIgu sumres{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | sumres{
                            $$ = $1;
                        }
                        ;
        
   

    sumres :             sumres tMas multdiv{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | sumres tMenos multdiv{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | multdiv{
                            $$ = $1;
                        }
                        ;
   



    multdiv :           multdiv tPor mod{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | multdiv tDivision mod{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | mod{
                            $$ = $1;
                        }
                        ;
   
        

    mod :               mod tMod ExprNeg{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            temp.addNodo($3);
                            $$ = temp;
                        }
                        | ExprNeg{
                            $$ = $1;
                        }
                        ;

  
   
    ExprNeg :           Expressn tMasm{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            $$ = temp;
                        }
                        | Expressn tMenosm{
                            id = inc();
                            var temp = new NodoArbol($2.toString(), id, null);
                            temp.addNodo($1);
                            $$ = temp;
                        }
                        | Expressn{
                            $$ = $1;
                        }
                        | tMenos Expressn{     
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        ;

    Expressn:            tPara logi tParc{
                            $$ = $1;                           
                        }
                        | Number{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Decimal{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Cadena1{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | Cadena2{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | ttrue{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | tfalse{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }
                        | tnull{
                            id = inc();
                            $$ = new NodoArbol($1.toString(), id, null);
                        }                 
                        | CALLLlist
                        ;
                
   


    CALLLlist :         CALLLlist tPunto CALLS
                        | CALLS
                        ;
     


    CALLS :             CALLS tPara paramstr tParc
                        | CALLS tPara  tParc 
                        | Identificador LISTACOR
                        | Identificador LISTACDOS
                        | Identificador 
                        ;

    LISTACDOS :         LISTACDOS tCorizq logi tCorder
                        | tCorizq logi tCorder
                        ;


    paramstr:          paramstr tComa logi
                        | logi 
                        ;