:- use_module(library(clpfd)).

list([], [], _).
list([E|Es], [NewPair|Result], N) :-
    E = (A, B),
    N #> 0,
    Double #= B * N,
    NewPair = (A, Double),
    list(Es, Result, N).

append([],List,List).
append([Head|Tail],List2,[Head|Result]) :-
    append(Tail,List2,Result).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Ingredients details
I - Name
Q - Quantity
M - Measurement scale
D - Applies every how many dinners
R - required?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
baseRecipe_updatedRecipe_diners

Updates base recipe according to the number of diners
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

base_diners_updated([],Diners,[]).
base_diners_updated([(I0,Q0,M0,D0,R_O0)|Is],Diners,[CalcIngredient|Result]) :-
    N0 #= max((Diners div D0),1),
    Q1 #= Q0 * N0,
    CalcIngredient = (I0,Q1,M0,N0,R_O0),
    base_diners_updated(Is,Diners,Result).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Calculates the ingredients for any given recipe based on the number of diners
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

recipe_diners_ingredients(Name,Diners,Ingredients) :-
    recipes(Recipes),
    member(Name,Recipes),
    atom_concat(Name,'_ingredients',O),
    call(O,N1,BaseRecipe),
    base_diners_updated(BaseRecipe,Diners,Ingredients).
    
    
?- recipe_diners_ingredients(risotto,2,Ingredients).
%@ Ingredients = [("Saffron", 2, "grams", 1, optional),  ("Courgette", 350, "grams", 1, optional),  ("Red pepper", 250, "grams", 1, optional),  ("Onion", 150, "grams", 1, required),  ("Vegetable stock cube", 20, "grams", 1, optional),  ("Risotto rice", 160, "grams", ..., ...),  ("Cherry tomatoes", 120, ..., ...),  ("Garlic clove", ..., ...),  (..., ...)|...].
%@ Ingredients = [("Saffron", 2, "grams", 1, optional),  ("Courgette", 700, "grams", 2, optional),  ("Red pepper", 500, "grams", 2, optional),  ("Onion", 300, "grams", 2, required),  ("Vegetable stock cube", 20, "grams", 1, optional),  ("Risotto rice", 400, "grams", ..., ...),  ("Cherry tomatoes", 240, ..., ...),  ("Garlic clove", ..., ...),  (..., ...)|...].


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
List of all available recipes. Atom names
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

recipes([shakshouka,risotto]).

ingredients(["Black pepper","Cherry tomatoes","Courgette","Cumin","Eggs","Feta cheese","Garlic","Green chilli","Green pepper","Olive oil","Onion","Onion","Paprika","Parsley","Pita bread","Red pepper","Risotto rice","Saffron","Salt","Tomatoes","Vegetable stock cube"]).

?- recipes(R).

?- ingredients(I).
%@ I = ["Black pepper", "Cherry tomatoes", "Courgette", "Cumin", "Eggs", "Feta cheese", "Garlic", "Green chilli", "Green pepper"|...].

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SHAKSOUKA ingredients
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

shakshouka_ingredients(Name,Ingredients) :-
    Name = "Shakshouka",
    Ingredients = [
	("Eggs",1,"items",1,required),
	("Green pepper",250,"grams",2,required),
	("Onion",150,"grams",2,required),
	("Tomatoes",350,"grams",1,required),
	("Feta cheese",50,"grams",2,required),
	("Green chilli",4,"grams",2,optional),
	("Paprika",1,"table spoons",2,optional),
	("Cumin",1,"table spoons",2,required),
	("Garlic",20,"grams",3,required),
	("Parsley",10,"grams",2,optional),
	("Pita bread",2,"items",1,optional),
	("Olive oil",2,"table spoons",2,required),
	("Salt",2,"tea_spoons",3,required),
	("Black pepper",2,"grams",3,optional)
    ].

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
RISOTTO ingredients
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

risotto_ingredients(Name, Ingredients) :-
    Name = "Risotto",
    Ingredients = [
	    ("Saffron",2,"grams",5,optional),
	    ("Courgette",350,"grams",2,optional),
	    ("Red pepper",250,"grams",2,optional),
	    ("Onion",150,"grams",2,required),
	    ("Vegetable stock cube",20,"grams",10,optional),
	    ("Risotto rice",80,"grams",1,required),
	    ("Cherry tomatoes",120,"grams",2,required),
	    ("Garlic",10,"grams",3,required),
	    ("Olive oil",2,"table spoons",2,required),
	    ("Salt",2,"tea spoons",3,required),
	    ("Grounded Black pepper",2,"grams",3,optional)
    ].


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
List of ingredients for a given list of recipies
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
recipes_ingredients([],[]).
recipes_ingredients([R|Rs], [(Name,Ingredients)|RIs]) :-
    atom_concat(R,'_ingredients',O),
    call(O,Name,Ingredients),
    recipes_ingredients(Rs,RIs).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
List of only required ingredients from a list of ingridients
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
recipe_required([],[]).
recipe_required([(Name,Qty,Mea,Din,required)|Is],[Name|RIs]) :-
    recipe_required(Is,RIs).
recipe_required([(Name,Qty,Mea,Din,optional)|Is],RIs) :-
    recipe_required(Is,RIs).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
List of doable recipies given a list of available ingredients and diners
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
doableRecipes([],AIs,D,[]).
doableRecipes([(RecipeName,Ingredients)|Rs],AvailableIngredients,Diners,[RecipeName|Result]) :-
    recipe_required(Ingredients,RequiredIngredients),
    subset(RequiredIngredients,AvailableIngredients),
    recipeQs_availableQs(),
    doableRecipes(Rs,AvailableIngredients,Diners,Result).
doableRecipes([Recipe|Rs],AvailableIngredients,Diners,Result) :-
    doableRecipes(Rs,AvailableIngredients,Diners,Result).
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Missing check on ingredient quantities based on diners - to be added
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


available_diners_recipes(AvailableIngredients,Diners,Result) :-
    recipes(Names),
    recipes_ingredients(Names,Recipes),
    doableRecipes(Recipes,AvailableIngredients,Diners,Result).




