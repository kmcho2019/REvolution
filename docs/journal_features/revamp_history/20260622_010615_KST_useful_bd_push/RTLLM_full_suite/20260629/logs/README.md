# Logs

The tmux launcher writes one log per method plus packaging logs here.

Sentinel files:

- `<method>.done`: method command exited successfully.
- `<method>.failed`: method command failed.
- `package.done`: packaging completed.
- `package.failed`: packaging failed.

The live experiment artifacts are under
`/workspace/exp/useful_bd_push/rtllm_full_suite_20260629/live`.
