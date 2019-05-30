grid_build(N,M):-
length(R,N),
gomakeM(R,N),
M=R.

gomakeM([],N).
gomakeM([H|T],N):-
	length(M,N),H=M,gomakeM(T,N).


grid_gen(N,M):-
	grid_build(N,M),num_gen(1,N,R),gogenlist(M,N,R).

gogenlist([],N,R).
gogenlist([H|T],N,R):-
	tweaked_permutation(R,N,Res),H=Res,gogenlist(T,N,R).


tweaked_permutation(List,N,R):-
	length(R,N),go_make_perm(R,List).

go_make_perm([],_).
go_make_perm([H|T],List):-
	member(R,List),H=R,go_make_perm(T,List).



num_gen(X,N,R):-
	num_gen1(X,N,K),reverse1(K,[],M),R=M.

num_gen1(X,N,[]):-
	X1 is X-1,N==X1.
num_gen1(X,N,R):-
	N>=X,M is N-1,num_gen1(X,M,R1),R=[N|R1].

reverse1([],Acc,Acc).
reverse1([H|T],Acc,M):-
	Accn=[H|Acc],reverse1(T,Accn,M).

check_num_grid(G):-
	gogetmax(G,0,M),num_gen(1,M,R),arrange_all_num(G,[],N),
	intersection(R,N,U),length(U,L1),length(R,L2),L2==L1.


gogetmax([],M,M).
gogetmax([H|T],M,N):-
	gogetmaxlist(H,0,Y),Y>=M,gogetmax(T,Y,N).
gogetmax([H|T],M,N):-
	gogetmaxlist(H,0,Y),\+(Y>=M),gogetmax(T,M,N).


gogetmaxlist([],M,M).
gogetmaxlist([H|T],M,N):-
	H>=M,gogetmaxlist(T,H,N).
gogetmaxlist([H|T],M,N):-
	\+(H>=M),gogetmaxlist(T,M,N).	

arrange_all_num([],M,M).
arrange_all_num([H|T],M,N):-
	arrange_all_numlist(H,M,K),arrange_all_num(T,K,N).
	
arrange_all_numlist([],M,M).
arrange_all_numlist([H|T],M,N):-
	M1=[H|M],arrange_all_numlist(T,M1,N).

acceptable_distribution(G):-
	length(G,L),L1 is L+1,go_put_them_inlist(G,1,L1,[],Result),
	reversing(Result,R),reverse1(R,[],M),last_check(M,G).

last_check([],[]).
last_check([H|T],[H1|T1]):-
	H\==H1,last_check(T,T1).	

reversing([],[]).
reversing([H|T],R):-
	reverse1(H,[],Re),reversing(T,R1),R=[Re|R1].



go_put_them_inlist(_,L,L,Acc,Acc).
go_put_them_inlist(G,N,L,Acc,Result):-
	N\==L,make_coloumn(G,1,N,[],Res),Accn=[Res|Acc],N1 is N+1,go_put_them_inlist(G,N1,L,Accn,Result).

make_coloumn([],_,_,Acc,Acc).
make_coloumn([H|T],F,N,Acc,Res):-
	get_num(H,1,N,R),Accn=[R|Acc],make_coloumn(T,1,N,Accn,Res).


get_num([H|T],N,N,H).
get_num([H|T],F,N,R):-
	F\==N,F1 is F+1,get_num(T,F1,N,R).	

trans(M,M1):-
	length(M,L),L1 is L+1,go_put_them_inlist(M,1,L1,[],Result),
	reversing(Result,R),reverse1(R,[],J),M1=J.


distinct_rows(M):-
	compare(M).


compare([H]).
compare([H|T]):-
	\+member(H,T),compare(T).

distinct_columns(M):-
	trans(M,M1),distinct_rows(M1).

check_rows_col(G):-
	length(G,L),L1 is L+1,go_put_them_inlist(G,1,L1,[],Result),reversing(Result,R),reverse1(R,[],M),
	compare_rows_col(M,G).

compare_rows_col([],_).
compare_rows_col([H|T],N):-
	member(H,N),compare_rows_col(T,N).

acceptable_permutation(L,R):-
	permutation(L,L1),go_check_positionschanged(L,L1),R=L1.


go_check_positionschanged([],[]).
go_check_positionschanged([H1|T1],[H2|T2]):-
	H2\==H1,go_check_positionschanged(T1,T2).

row_col_match(G):-
check_rows_col(G),acceptable_distribution(G).

helsinki(N,G):-
	grid_build(N,M),row_col_match(M),grid_gen(N,M),check_num_grid(M),
	acceptable_distribution(M),G=M.



arrange1([],Acc,Acc).
arrange1([H|T],Acc,B):-
append(Acc,H,Accn),arrange1(T,Accn,B).


