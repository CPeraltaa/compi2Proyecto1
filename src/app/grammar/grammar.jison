



/*Segmento de codigo*/
%{
    const {NodoArbol, DrawArbol} = require('../ast/ast');

    var id = 0;

    function inc(){
        id++;
        return id;
    }

    var raiz = new NodoArbol("s", -1, null);
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
                            return $1;
                        }
                        ;

INICIO:                 LINSTRUCCIONES
                        ;


LINSTRUCCIONES:         LINSTRUCCIONES INSTRUCCIONES
                        | INSTRUCCIONES
                        ;

INSTRUCCIONES:          FUNCION 
                        | DEC_VARIABLE
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

TYPEFUNCION:             TYPEVAR
                        | tVoid
                        | Identificador;


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

LISTAVAR:           LISTAVAR tComa Identificador tDosPts LISTYPE
                    | Identificador tDosPts LISTYPE
                    ;




LISTYPE:        TYPEVAR
                | Identificador
                ;

//LISTA DE INSTUCCIONES DE UNA FUNCION


INSTRUCCIONESFUNR:      INSTRUCCIONESFUNR INSTRUFUN
                        | INSTRUFUN
                        ;

//PARAMETROS DE FUNCION

LPRAMFUNC:              LPRAMFUNC tComa PARAMFUNCION
                        | PARAMFUNCION
                        ;

PARAMFUNCION:           Identificador tDosPts TYPEVAR tIgual logi
                        | Identificador tTern tDosPts TYPEVAR
                        | Identificador tDosPts TYPEVAR
                        | Identificador tDosPts Identificador tIgual logi
                        | Identificador tTern tDosPts Identificador
                        | Identificador tDosPts Identificador
                        | Identificador tDosPts TYPEVAR LISTACOR
                        | Identificador tDosPts Identificador LISTACOR
                        ;





//DECLARACION DE VARIABLES 


LISTDECID:              LISTDECID  tComa TIPODEDECL{
                            id = inc();
                            var temp = new NodoArbol("Let", id, null);
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
                            $$ = new NodoArbol($1.toString(), id, null);                            
                        }
                        | Identificador tDosPts TYPEVAR{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();                      
                            temp.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts Identificador{
                            id = inc();
                            var temp = new NodoArbol($3.toString(), id, null);
                            id = inc();                         
                            temp.addNodo(new NodoArbol($1.toString(), id, null));
                            $$ = temp;
                        }
                        | Identificador tDosPts TYPEVAR tIgual  VARIGUA
                        | Identificador tDosPts Identificador tIgual  VARIGUA
                        | Identificador tIgual VARIGUA
                        | Identificador tDosPts Array tMenor TYPEVAR tMayor
                        | Identificador tDosPts Array tMenor Identificador tMayor
                        | Identificador tDosPts TYPEVAR LISTACOR
                        | Identificador tDosPts Identificador LISTACOR
                        | Identificador tDosPts TYPEVAR LISTACOR tIgual tCorizq tCorder
                        | Identificador tDosPts Identificador LISTACOR tIgual tCorizq tCorder
                        | Identificador tDosPts Array tMenor TYPEVAR tMayor tIgual tCorizq LISCOND tCorder
                        | Identificador tDosPts Array tMenor Identificador tMayor tIgual tCorizq LISCOND tCorder
                        | Identificador tDosPts TYPEVAR LISTACOR tIgual tCorizq LISCOND tCorder
                        | Identificador tDosPts Identificador LISTACOR tIgual tCorizq LISCOND tCorder
                        
                        ;

VARIGUA:    logi{
                $$ = $1;
            }
            | tLlavea LISTAVAR tLlavec 
            ;



DEC_VARIABLE:           tlet LISTDECID tPtcoma{
                            id = inc();
                            var temp = new NodoArbol($1.toString(), id, null);
                            temp.addNodo($2);
                            $$ = temp;
                        }
                        | tconst Identificador tDosPts TYPEVAR tIgual logi tPtcoma
                        | tconst Identificador tIgual logi tPtcoma

                        ;


//LIST logi
LISCOND:                LISCOND tComa logi
                        | logi
                        ;


LISTACOR:               LISTACOR tCorizq tCorder
                        | tCorizq tCorder
                        ;







/* LCPARAM1:               LCPARAML                    
                        | EPSILON                                 
                        ;             
 */



BODYFUN:                BODYFUN INS_FUN
                        | INS_FUN                                   
                        ;


INS_FUN:                CNIF_F                    
                        | WHILE_F                                
                        | SWITCH_F                    
                        | ACCSATRI tPtcoma                                                     
                        | DO_F                                
                        | FOR_F                            
                        | DEC_VARIABLE   
                        | ASIG_VARIABLE                                
                        | logi tPtcoma                            
                        | tReturn logi tPtcoma     
                        | tReturn tPtcoma                  
                        | error tPtcoma                                
                        ;


// INICO  SENTENCIA IF
CNIF_F:                 tif tPara logi tParc tLlavea BODYFUN tLlavec ELSEIF_F telse tLlavea BODYFUN tLlavec
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec telse tLlavea BODYFUN tLlavec                  
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec ELSEIF_F                  
                        | tif tPara logi tParc tLlavea BODYFUN tLlavec 
                        //| tif  error tPtcoma                     
                        ;



ELSEIF_F:               ELSEIF_F EI_F
                        | EI_F                  
                        ;


 EI_F:                  telse tif tPara logi tParc tLlavea BODYFUN tLlavec  
                       ;    



// INICO  SENTENCIA SWITCH
SWITCH_F:               tswitch tPara logi tParc tLlavea LCASE_F tdefault tDosPts BODYFUN tBreak tPtcoma tLlavec
                        | tswitch tPara logi tParc tLlavea LCASE_F tdefault tDosPts BODYFUN  tLlavec
                        | tswitch tPara logi tParc tLlavea LCASE_F  tLlavec
                        ;
    
                  


LCASE_F:                LCASE_F CASE_F
                        | CASE_F
                        ;


CASE_F:                 tcase VALOP tDosPts BODYFUN tBreak tPtcoma
                        | tcase VALOP tDosPts BODYFUN 
                        ;

VALOP:                  | Cadena1
                        | Decimal
                        | Number
                        | Cadena2
                        ;

//WHILE 

WHILE_F:                twhile tPara logi tParc tLlavea BODYFUN tLlavec
                        ;

 
//DO DE UNA FUNCION:                                  
DO_F:                   tdo tLlavea BODYFUN tLlavec twhile tPara logi tParc tPtcoma
                        ;

// FOR DE UNA FUNCION
FOR_F:                  tfor tPara FORCON tParc tLlavea BODYFUN tLlavec
                        ;                        

FORCON:                 tlet Identificador tIgual logi tPtcoma logi tPtcoma logi
                        | tlet Identificador tof Identificador
                        | tlet Identificador tin Identificador

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