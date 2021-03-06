(* $Id: mergeDup.ml,v 5.9 2007-09-12 09:58:44 ddr Exp $ *)
(* Copyright (c) 2007 INRIA *)

open Config
open Gwdb
open Util

let print_link conf base p =
  Output.printf conf "<a href=\"%s%s\">" (commd conf) (acces conf base p);
  Output.printf conf "%s.%d %s" (sou base (get_first_name p)) (get_occ p)
    (sou base (get_surname p));
  Output.print_string conf "</a>";
  Output.print_string conf (DateDisplay.short_dates_text conf base p);
  match main_title conf base p with
    Some t -> Output.print_string conf (one_title_text base t)
  | None -> ()

let print_no_candidate conf base p =
  let title _ =
    Output.printf conf "%s\n"
      (Utf8.capitalize_fst
         (transl_decline conf "merge" (transl conf "possible duplications")))
  in
  Hutil.header conf title;
  Hutil.print_link_to_welcome conf true;
  Output.printf conf "%s\n" (Utf8.capitalize_fst (transl conf "not found"));
  Output.print_string conf "<ul>\n";
  Output.print_string conf "<li>\n";
  print_link conf base p;
  Output.print_string conf "</li>\n";
  Output.print_string conf "</ul>\n";
  Hutil.trailer conf

let input_excl string_of_i excl =
  List.fold_left
    (fun s (i1, i2) ->
       let t = string_of_i i1 ^ "," ^ string_of_i i2 in
       if s = "" then t else s ^ "," ^ t)
    "" excl

let print_input_excl conf string_of_i excl excl_name =
  let s = input_excl string_of_i excl in
  if s = "" then ()
  else
    Output.printf conf "<input type=\"hidden\" name=\"%s\" value=\"%s\">\n"
      excl_name s

let print_cand_ind conf base (ip, p) (iexcl, fexcl) ip1 ip2 =
  let title _ = Output.printf conf "%s\n" (Utf8.capitalize_fst (transl conf "merge")) in
  Perso.interp_notempl_with_menu title "perso_header" conf base p;
  Output.print_string conf "<h2>\n";
  title false;
  Output.print_string conf "</h2>\n";
  Hutil.print_link_to_welcome conf true;
  Output.print_string conf "<ul>\n";
  Output.print_string conf "<li>\n";
  print_link conf base (poi base ip1);
  Output.print_string conf "</li>\n";
  Output.print_string conf "<li>\n";
  print_link conf base (poi base ip2);
  Output.print_string conf "</li>\n";
  Output.print_string conf "</ul>\n";
  Output.print_string conf "<p>\n";
  Output.printf conf "%s ?\n" (Utf8.capitalize_fst (transl conf "merge"));
  Output.printf conf "<form method=\"post\" action=\"%s\">\n" conf.command;
  Util.hidden_env conf;
  Output.print_string conf
    "<input type=\"hidden\" name=\"m\" value=\"MRG_DUP_IND_Y_N\">\n";
  Output.printf conf "<input type=\"hidden\" name=\"ip\" value=\"%s\">\n"
    (string_of_iper ip);
  print_input_excl conf string_of_iper ((ip1, ip2) :: iexcl) "iexcl";
  print_input_excl conf string_of_ifam fexcl "fexcl";
  Output.printf conf "<input type=\"hidden\" name=\"i\" value=\"%s\">\n"
    (string_of_iper ip1);
  Output.printf conf "<input type=\"hidden\" name=\"select\" value=\"%s\">\n"
    (string_of_iper ip2);
  Output.printf conf "<input type=\"submit\" name=\"answer_y\" value=\"%s\">\n"
    (transl_nth conf "Y/N" 0);
  Output.printf conf "<input type=\"submit\" name=\"answer_n\" value=\"%s\">\n"
    (transl_nth conf "Y/N" 1);
  Output.print_string conf "</form>\n";
  Output.print_string conf "</p>\n";
  Hutil.trailer conf

let print_cand_fam conf base (ip, p) (iexcl, fexcl) ifam1 ifam2 =
  let title _ =
    Output.printf conf "%s\n"
      (Utf8.capitalize_fst
         (transl_decline conf "merge" (transl_nth conf "family/families" 1)))
  in
  Perso.interp_notempl_with_menu title "perso_header" conf base p;
  Output.print_string conf "<h2>\n";
  title false;
  Output.print_string conf "</h2>\n";
  Hutil.print_link_to_welcome conf true;
  let (ip1, ip2) =
    let cpl = foi base ifam1 in Gwdb.get_father cpl, Gwdb.get_mother cpl
  in
  Output.print_string conf "<ul>\n";
  Output.print_string conf "<li>\n";
  print_link conf base (poi base ip1);
  Output.print_string conf "\n&amp;\n";
  print_link conf base (poi base ip2);
  Output.print_string conf "</li>\n";
  Output.print_string conf "<li>\n";
  print_link conf base (poi base ip1);
  Output.print_string conf "\n&amp;\n";
  print_link conf base (poi base ip2);
  Output.print_string conf "</li>\n";
  Output.print_string conf "</ul>\n";
  Output.print_string conf "<p>\n";
  Output.printf conf "%s ?\n" (Utf8.capitalize_fst (transl conf "merge"));
  Output.printf conf "<form method=\"post\" action=\"%s\">\n" conf.command;
  Util.hidden_env conf;
  Output.print_string conf
    "<input type=\"hidden\" name=\"m\" value=\"MRG_DUP_FAM_Y_N\">\n";
  Output.printf conf "<input type=\"hidden\" name=\"ip\" value=\"%s\">\n"
    (string_of_iper ip);
  print_input_excl conf string_of_iper iexcl "iexcl";
  print_input_excl conf string_of_ifam ((ifam1, ifam2) :: fexcl) "fexcl";
  Output.printf conf "<input type=\"hidden\" name=\"i\" value=\"%s\">\n"
    (string_of_ifam ifam1);
  Output.printf conf "<input type=\"hidden\" name=\"i2\" value=\"%s\">\n"
    (string_of_ifam ifam2);
  Output.printf conf "<input type=\"submit\" name=\"answer_y\" value=\"%s\">\n"
    (transl_nth conf "Y/N" 0);
  Output.printf conf "<input type=\"submit\" name=\"answer_n\" value=\"%s\">\n"
    (transl_nth conf "Y/N" 1);
  Output.print_string conf "</form>\n";
  Output.print_string conf "</p>\n";
  Hutil.trailer conf

let main_page conf base =
  let ipp =
    match p_getenv conf.env "ip" with
    | Some i -> let i = iper_of_string i in Some (i, poi base i)
    | None -> None
  in
  let excl = Perso.excluded_possible_duplications conf in
  match ipp with
    Some (ip, p) ->
      begin match Perso.first_possible_duplication base ip excl with
        Perso.DupInd (ip1, ip2) ->
          print_cand_ind conf base (ip, p) excl ip1 ip2
      | Perso.DupFam (ifam1, ifam2) ->
          print_cand_fam conf base (ip, p) excl ifam1 ifam2
      | Perso.NoDup -> print_no_candidate conf base p
      end
  | None -> Hutil.incorrect_request conf

let answ_ind_y_n conf base =
  let yes = p_getenv conf.env "answer_y" <> None in
  if yes then MergeIndDisplay.print conf base else main_page conf base

let answ_fam_y_n conf base =
  let yes = p_getenv conf.env "answer_y" <> None in
  if yes then MergeFamDisplay.print conf base else main_page conf base
