# FEMLab.jl

![alt text](examples/airfoil_mesh.png)

_`FEMLab.jl` → A starter pack for students who are new to Julia and want to use it to solve FEM assignments._

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

## REPL

The `REPL` has five different prompt modes. The default mode (Julian, green) is where standard Julia expressions can be evaluated.
The special modes can be activated by pressing: `]`,`?`, `;`, or `Ctrl+R`. The default mode is reactivated by removing all
input or by pressing `Ctrl+C`.

### Package mode
Package mode (`]`) allows, among others, for adding packages to the current environment.
<!--StartFragment-->
<pre><div><div><span></span><span style='color: #2472c8; font-weight: bold;'>(@v1.12) pkg> </span><span>activate .                                                                                                                                                                                                          </span></div><div><span></span><span style='color: #0dbc79; font-weight: bold;'>  Activating</span><span> project at `/scratch/mika/FEMLab.jl`                                                                                                                                                                                 </span></div><div><span>                                                                                                                                                                                                                                  </span></div><div><span></span><span style='color: #2472c8; font-weight: bold;'>(FEMLab) pkg> </span><span>add LinearAlgebra                                                                                                                                                                                                   </span></div><div><span></span><span style='color: #0dbc79; font-weight: bold;'>   Resolving</span><span> package versions...                                                                                                                                                                                                  </span></div><div><span></span><span style='color: #0dbc79; font-weight: bold;'>      Compat</span><span> entries added for LinearAlgebra                                                                                                                                                                                      </span></div><div><span></span><span style='color: #0dbc79; font-weight: bold;'>    Updating</span><span> `/scratch/mika/FEMLab.jl/Project.toml`                                                                                                                                                                               </span></div><div><span>  </span><span style='color: #666666;'>[37e2e46d] </span><span style='color: #23d18b;'>+ LinearAlgebra v1.12.0</span><span>                                                                                                                                                                                              </span></div><div><span></span><span style='color: #11a8cd; font-weight: bold;'>    Manifest</span><span> No packages added to or removed from `/scratch/mika/FEMLab.jl/Manifest.toml`      </span></div></div></pre>
<!--EndFragment-->

### Help mode
Help mode (`?`) can be used to print help and documentation for anything entered in help mode.
<!--StartFragment-->
<pre><div><div><span></span><span style='color: #e5e510; font-weight: bold;'>help?> </span><span>help                                                                                                                                                                                         </span></div><div><span>search: </span><span style='font-weight: bold;'>help</span><span> exp </span><span style='font-weight: bold;'>he</span><span>x                                                                                                                                                                                </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  </span><span style='font-weight: bold;'>Welcome to Julia 1.12.6.</span><span> The full manual is available at                                                                                                                                          </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  </span><span style='color: #11a8cd;'>https://docs.julialang.org</span><span>                                                                                                                                                                        </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  as well as many great tutorials and learning resources:                                                                                                                                           </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  </span><span style='color: #11a8cd;'>https://julialang.org/learning/</span><span>                                                                                                                                                                   </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  For help on a specific function or macro, type </span><span style='color: #11a8cd;'>?</span><span> followed by its name, e.g. </span><span style='color: #11a8cd;'>?cos</span><span>, or </span><span style='color: #11a8cd;'>?@time</span><span>, and press enter. Type </span><span style='color: #11a8cd;'>;</span><span> to enter shell mode, </span><span style='color: #11a8cd;'>]</span><span> to enter package mode.                                </span></div><div><span>                                                                                                                                                                                                    </span></div><div><span>  To exit the interactive session, type </span><span style='color: #11a8cd;'>CTRL-D</span><span> (press the control key together with the </span><span style='color: #11a8cd;'>d</span><span> key), or type </span><span style='color: #11a8cd;'>exit()</span><span>.    </span></div></div></pre>
<!--EndFragment-->

### Shell mode
Shell mode (`;`) acts like a simple system shell.
<!--StartFragment-->
<pre><div><div><span></span><span style='color: #cd3131; font-weight: bold;'>shell> </span><span>ls                                                                                                                                                                                           </span></div><div><span>examples  LICENSE  Manifest.toml  noshare  Project.toml  README.md  repl.html  results  src  tests </span></div></div></pre>
<!--EndFragment-->


### Search mode
Search mode (`Ctrl+R`) allows for searching through the history of commands.
<!--StartFragment-->
<pre><div><div><span>(reverse-i-search)`ls': ls -a        </span></div></div></pre>
<!--EndFragment-->

## First steps

Now, that Julia and VS Code are up and running, `FEMLab.jl` can be initialized. This
will download any dependencies defined in `Project.toml`.

First, check that the project environment is activated. This can be done by entering the
package mode (`]`). It should read

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
> The `FEMLab` environment must be active if you want to use it! VS Code should
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
julia> include(REPL.softscope, "examples/airfoil_mesh.jl")
```

You can read up on the reason why `REPL.softscope` is necessary in this context
[here](https://docs.julialang.org/en/v1/manual/variables-and-scoping/).


Links to the documentation of Julia and the packages reexported by FEMLab are in `src/FEMLab.jl`.
The output files (`*.vtu`,`*.vts`,...) can be opened in [Paraview](https://www.paraview.org/).
The included packages are sufficient for the solution of all course assignments.

The repository structure can be used as a starting point for your own package. If you wish you can also just keep working inside the `FEMLab.jl` directory.