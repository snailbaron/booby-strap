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
