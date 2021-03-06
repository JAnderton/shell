scenario "Add a file and edit commit message" \
    given_repo \
        and_add_file with_message "A commit" \
    when_recommit with_message "B commit" \
    then_editor_was <<'EOB' \
        and_first_line_replaced
A commit
--This line, and those below, will be ignored--

A    /a-file
EOB

scenario "Move a file and edit commit message" \
    given_repo \
        and_move_file with_message "A commit" \
    when_recommit with_message "B commit" \
    then_editor_was <<'EOB' \
        and_first_line_replaced
A commit
--This line, and those below, will be ignored--

D    /a-file
A    /b-file (from /a-file:2)
EOB

scenario "Delete a file and edit commit message" \
    given_repo \
        and_delete_file with_message "A commit" \
    when_recommit with_message "B commit" \
    then_editor_was <<'EOB' \
        and_first_line_replaced
A commit
--This line, and those below, will be ignored--

D    /a-file
EOB
