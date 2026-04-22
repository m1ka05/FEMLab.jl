# FEMLab.jl

Starter pack for students new to Julia who are using it to solve FEM assignments.


## Setup

1. Install [Julia](https://julialang.org/downloads/)
2. In Visual Studio Code install [Julia extension](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia)
3. Open the directory `FEMLab.jl` in Visual Studio Code and trust the authors
4. Open Julia `REPL` (read-eval-print loop):
    - by opening the command window (`Ctrl+Shift+P`) and searching for `Julia: Start REPL`; or
    - by pressing (`Alt+J`) followed by (`Alt+O`)

> [!TIP]
> Visual Studio Code may ask about installing [`Revise.jl`](https://github.com/timholy/Revise.jl).
> `Revise.jl` allows you to modify code and use the changes without restarting Julia. This is quite useful.

The `REPL` has five different prompt modes. The default mode (Julian, green) is where standard Julia expression can be evaluated.
The special modes can be activated by pressing: `]`,`?`, `;`, or `Ctrl+R`. The default mode is reactivated by removing all
input or by pressing `Ctrl+C`.

- Package mode (`]`, blue) allows for adding packages to the current environment
- Help mode (`?`, yellow) can be used to print help and documentation for anything entered in help mode.
- Shell mode (`;`, red) acts like a regular terminal
- Search mode (`Ctrl+R`, white) allows for searching through the history of commands

## First steps

Now, that Julia and VS Code are up and running, `FEMLab.jl` can be initialized. This
will download any dependencies defined in `Project.toml`.

First, check that the project environment is activated. This can be done by entering the
package mode (`]`, blue). It should read

```julia-repl
(FEMLab) pkg>
```

If instead you see

```julia-repl
(@v1.12) pkg>
```

Then either enter `activate .` in the package mode, or press `Ctrl+Shift+P` and search for `Julia: Activate This Environment`.

```julia-repl
(@v1.12) pkg> activate .
  Activating project at `/scratch/user/FEMLab.jl`

(FEMLab) pkg>
```

> [!IMPORTANT]
> The `FEMLab` environment must be activate if you want to use it! VS Code should
> create a `.vscode/settings.json` with a path set for `julia.environmentPath`. This
> should then be automatically activated whenever the directory is opened in VS Code.

To download all dependencies run
```
(FEMLab) pkg> instantiate
```

## Next steps

Some examples are included in the `examples` directory. Note, that `using FEMLab` must be
evaluated at least once to load the module functionality. The examples can be run
by pressing `Shift+Enter` in each line, or by selecting parts of the code and pressing
`Shift+Enter` again. You can also run whole scripts by

```julia-repl
julia> using REPL
julia> include(REPL.softscope, "examples/dsm.jl")
```

You can read up on the reason why `REPL.softscope` is necessary in this context
[here](https://docs.julialang.org/en/v1/manual/variables-and-scoping/).


Links to the documentation of Julia and the packages reexported by FEMLab are in `src/FEMLab.jl`.
The output files (`*.vtu`,`*.vts`,...) can be opened in [Paraview](https://www.paraview.org/).
The included packages are sufficient for the solution of all course assignments.
