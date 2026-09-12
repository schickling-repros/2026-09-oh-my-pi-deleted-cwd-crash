# Oh My Pi — deleted working directory terminates the session

OMP terminates with an uncaught `process.cwd()` error when its working directory disappears during an active session.

## Reproduction

Install OMP 18.1.18 and run:

```bash
./repro.sh
```

The script creates an isolated temporary working directory. A minimal OMP extension removes that directory during `session_start`. OMP then reaches an unhandled `process.cwd()` failure before making a model request.

## Expected

OMP should keep the session alive and report that the working directory no longer exists. Operations that require the directory should fail with a recoverable error.

## Actual

OMP terminates with exit status 1:

```text
ENOENT: process.cwd failed with error no such file or directory, the current working directory was likely removed without changing the working directory, uv_cwd
 syscall: "uv_cwd",
   errno: -2,
    code: "ENOENT"
```

## Versions

- OMP: 18.1.18
- Runtime: bundled Bun standalone executable
- OS: Linux x86_64

The original failure was also observed with OMP 18.1.14. The regression range is unknown.

## Related Issue

Pending.
