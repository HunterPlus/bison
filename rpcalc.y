/* reverse polish notation calculator. */

%{
	#include <stdio.h>
	#include <math.h>
	int	yylex (void);
	void	yyerror (char const *);
%}

%define api.value.type {double}
%token NUM

%% /* grammar rules and actions follow. */
input:
     	%empty
|	input line
;

line:
	'\n'
|	exp '\n'	{ printf ("%.10g\n", $1); }
;

exp:
   	NUM
|	exp exp '+'	{ $$ = $1 + $2; }
|	exp exp '-'	{ $$ = $1 - $2; }
| 	exp exp '*'	{ $$ = $1 * $2; }
| 	exp exp '/'	{ $$ = $1 / $2; }
|	exp exp '^'	{ $$ = pow ($1, $2); }	/* exponentiation */
|	exp 'n'		{ $$ = -$1;	}	/* unary minus	*/
;
%%

/* The lexical analyzer returns a double floating point number on
   the stack and the token NUM, or the numeric code of the character
   read if not a number. It skips all blanks and tabs, and returns 0 
   for end-of-input	*/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

int yylex(void)
{
	int c = getchar();
	/* skip white space. */
	while (c == ' ' || c == '\t')
		c = getchar();
	/* process numbers. */
	if (c == '.' || isdigit(c)) {
		ungetc(c, stdin);
		if (scanf("%lf", &yylval) != 1)
			abort();
		return NUM;
	}
	/* return end-of-input. */
	else if (c == EOF)
		return YYEOF;
	/* return a single char. */
	else
		return c;
}

/* called by yyparse on error. */
void yyerror(char const *s)
{
	fprintf(stderr, "%s\n", s);
}

int main()
{
	return yyparse();
}
