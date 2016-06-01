# vi: ft=bash
# Source me

SCENARIO 'Run echo on command line' \
    GIVEN first_time_in_repo \
        AND local_git \
    WHEN run_echo 'Uncle Bob' \
        with_program \
    THEN exit_with 0 \
        AND on_stdout 'Uncle Bob' \
        AND git_log_message 'echo Uncle Bob'

SCENARIO 'Run echo in pipeline' \
    GIVEN first_time_in_repo \
        AND local_git \
    WHEN run_echo 'Uncle Bob' \
        in_pipe 'First time' \
    THEN exit_with 0 \
        AND on_stdout 'Uncle Bob' \
        AND git_log_message 'First time'

