def _build_tool_impl(ctx):
    # type: (ctx) -> None

    out_file = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        outputs = [out_file],
        inputs = [ctx.file.src],
        executable = ctx.executable.tool,
        arguments = [ctx.file.src.path, out_file.path],
    )

    return DefaultInfo(
        executable = out_file,
    )

build_tool = rule(
    implementation = _build_tool_impl,
    doc = "Build an executable with a simple 'TOOL SRC OUT' command.",
    executable = True,
    attrs = {
        "tool": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "src": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
)

def _catm_impl(ctx):
    # type: (ctx) -> None

    out_file = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        outputs = [out_file],
        inputs = ctx.files.input_files,
        executable = ctx.executable._catm,
        arguments = [out_file.path] + [f.path for f in ctx.files.input_files],
    )

    return DefaultInfo(files = depset([out_file]))

catm = rule(
    implementation = _catm_impl,
    attrs = {
        "_catm": attr.label(
            default = ":catm",
            executable = True,
            cfg = "exec",
        ),
        "input_files": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
    },
)
