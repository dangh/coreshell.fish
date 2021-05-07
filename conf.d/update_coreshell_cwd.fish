function update_coreshell_cwd --argument-names cwd --on-event fish_prompt
  # Identify the directory using a "file:" scheme URL, including
  # the host name to disambiguate local vs. remote paths.

  # Percent-encode the pathname.
  test -n "$cwd" || set --local cwd (pwd)
  set --local url_path (string escape --style=url $cwd)

  if test -n "$TMUX"
    printf '\ePtmux;\e\e]7;%s\a\e\\' "file://""$HOSTNAME""$url_path"
  else
    printf '\e]7;%s\a' "file://""$HOSTNAME""$url_path"
  end
end

if test -n "$TMUX"
  set --local fish (which fish)
  tmux set-hook -g window-pane-changed 'run-shell "'$fish' -c \'update_coreshell_cwd \'#{pane_current_path}\'\'"'
end
