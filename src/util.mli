(* $Id: util.mli,v 1.1.1.1 1998-09-01 14:32:06 ddr Exp $ *)

open Def;
open Config;

value version : string;

value lang_dir : ref string;
value base_dir : ref string;

value html : config -> unit;

value commd : config -> string;
value code_varenv : string -> string;
value decode_varenv : string -> string;

value lendemain : (int * int * int) -> (int * int * int);
value age_autorise : config -> base -> base_person -> bool;

value enter_nobr : unit -> unit;
value exit_nobr : unit -> unit;

value connais : base -> base_person -> bool;
value acces : config -> base -> base_person -> string;
value calculer_age : config -> base_person -> option date;
value person_text : config -> base -> base_person -> string;
value person_text_no_html : config -> base -> base_person -> string;
value person_text_without_surname : config -> base -> base_person -> string;
(**)
value afficher_personne : config -> base -> base_person -> unit;
value afficher_prenom_de_personne_referencee :
  config -> base -> base_person -> unit;
value afficher_personne_referencee : config -> base -> base_person -> unit;
(**)
value afficher_prenom_de_personne : config -> base -> base_person -> unit;
value afficher_personne_titre : config -> base -> base_person -> unit;
value afficher_personne_titre_referencee : config -> base -> base_person -> unit;
value afficher_personne_un_titre_referencee :
  config -> base -> base_person -> title istr -> unit;
value afficher_personne_sans_titre : config -> base -> base_person -> unit;
value afficher_titre : config -> base -> base_person -> unit;
value afficher_un_titre :
  config -> base -> base_person -> title istr -> unit;
value p_getenv : list (string * string) -> string -> option string;
value p_getint : list (string * string) -> string -> option int;
value create_env : string -> list (string * string);
value capitale : string -> string;

value header : config -> (bool -> unit) -> unit;
value trailer : config -> unit;

value print_alphab_list : ('a -> string) -> ('a -> unit) -> list 'a -> unit;

value surname_begin : string -> string;
value surname_end : string -> string;

value enter_nobr : unit -> unit;
value exit_nobr : unit -> unit;

value preciser_homonyme : config -> base -> base_person -> unit;

value transl : config -> string -> string;
value transl_nth : config -> string -> int -> string;
value transl_concat : config -> string -> string -> string;
value ftransl : config -> format 'a 'b 'c -> format 'a 'b 'c;
value ftransl_nth : config -> format 'a 'b 'c -> int -> format 'a 'b 'c;
value fcapitale : format 'a 'b 'c -> format 'a 'b 'c;

value index_of_sex : sexe -> int;
value conjoint : base_person -> base_couple -> iper;

value incorrect_request : config -> unit;

value print_decimal_num : config -> float -> unit;

value find_person_in_env : config -> base -> string -> option base_person;

value quote_escaped : string -> string;
value rindex : string -> char -> option int;
