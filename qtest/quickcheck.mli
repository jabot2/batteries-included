val (==>) : bool -> bool -> bool
(** [b1 ==> b2] is the logical implication [b1 => b2]
    ie [not b1 || b2] (except that it is strict).
*)

type 'a gen_print = (unit -> 'a) * ('a -> string)
(** a value of type ['a gen_print] is a pair where the first
    component generates random value of type ['a] and the
    second component can print them.
*)

val unit : unit gen_print
(** always generates [()], obviously. *)

val bool : bool gen_print
(** uniform boolean generator *)

val float : float gen_print
(* FIXME: does not generate nan nor infinity I think *)
(** generates regular floats (no nan and no infinities) *)

val pos_float : float gen_print
(** positive float generator (no nan and no infinities) *)

val neg_float : float gen_print
(** negative float generator (no nan and no infinities) *)

val int : int gen_print
(** int generator. Uniformly distributed *)

val pos_int : int gen_print
(** positive int generator. Uniformly distributed *)

val small_int : int gen_print
(** positive int generator. The probability that a number is chosen
    is roughly an exponentially decreasing function of the number.
*)

val neg_int : int gen_print
(** negative int generator. The distribution is similar to that of
    [small_int], not of [pos_int].
*)

val char : char gen_print
(** Uniformly distributed on all the chars (not just ascii or
    valid latin-1) *)

val printable_char : char gen_print
(* FIXME: describe which subset *)
(** uniformly distributed over a subset of chars *)

val numeral_char : char gen_print
(** uniformy distributed over ['0'..'9'] *)

val string_gen_of_size : (unit -> int) -> (unit -> char) -> string gen_print

val string_gen : (unit -> char) -> string gen_print
(** generates strings with a distribution of length of [small_int] *)

val string : string gen_print
(** generates strings with a distribution of length of [small_int]
    and distribution of characters of [char] *)

val string_of_size : (unit -> int) -> string gen_print
(** generates strings with distribution of characters if [char] *)

val printable_string : string gen_print
(** generates strings with a distribution of length of [small_int]
    and distribution of characters of [printable_char] *)

val printable_string_of_size : (unit -> int) -> string gen_print
(** generates strings with distribution of characters of [printable_char] *)

val numeral_string : string gen_print
(** generates strings with a distribution of length of [small_int]
    and distribution of characters of [numeral_char] *)

val numeral_string_of_size : (unit -> int) -> string gen_print
(** generates strings with a distribution of characters of [numeral_char] *)

val list : 'a gen_print -> 'a list gen_print
(** generates lists with length generated by [small_int] *)

val list_of_size : (unit -> int) -> 'a gen_print -> 'a list gen_print
(** generates lists with length from the given distribution *)

val array : 'a gen_print -> 'a array gen_print
(** generates arrays with length generated by [small_int] *)

val array_of_size : (unit -> int) -> 'a gen_print -> 'a array gen_print
(** generates arrays with length from the given distribution *)

val pair : 'a gen_print -> 'b gen_print -> ('a * 'b) gen_print
(** combines two generators into a generator of pairs *)

val triple : 'a gen_print -> 'b gen_print -> 'c gen_print -> ('a * 'b * 'c) gen_print
(** combines three generators into a generator of 3-uples *)

val option : 'a gen_print -> 'a option gen_print
(**  *)

val fun1 : 'a gen_print -> 'b gen_print -> ('a -> 'b) gen_print
(** generator of functions of arity 1.
    The functions are always pure and total functions:
    - when given the same argument (as decided by Pervasives.(=)), it returns the same value
    - it never does side effects, like printing or never raise exceptions etc.
    The functions generated are really printable.
*)

val fun2 : 'a gen_print -> 'b gen_print -> 'c gen_print -> ('a -> 'b -> 'c) gen_print
(** generator of functions of arity 2. The remark about [fun1] also apply
    here.
*)

val laws_exn :
  ?small:('a -> int) ->
  ?count:int ->
  string -> 'a gen_print -> ('a -> bool) -> unit
 (** [laws_exn ?small ?count name gen law] generates up to [count] random
     values of type ['a] with using [gen]. The predicate [law] is called
     on them and if it returns [false] or raises an exception then we have a
     counter example for the [law].

     If [small] is given, then some other random values are generated and the
     smallest one (where compare [example1] [example2] is defined as
     [Pervasives.compare (small (example1)) (small (example2))]) is kept.

     If [small] is not given, then the generations stop at the first counter
     example.

     If a counter example has been found, then it an exception that contains
     the stringified example is thrown.
 *)