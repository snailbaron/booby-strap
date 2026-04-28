load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc:cc_toolchain_config_lib.bzl", "action_config", "tool")
load("@rules_cc//cc:defs.bzl", "cc_common")

def _bootstrap_impl(ctx):
    # type: (ctx) -> CcToolchainConfigInfo

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        action_configs = [
            action_config(
                action_name = ACTION_NAMES.c_compile,
                enabled = True,
                tools = [tool(tool = ctx.file._gcc)],
            ),
            action_config(
                action_name = ACTION_NAMES.cpp_compile,
                enabled = True,
                tools = [tool(tool = ctx.file._gxx)],
            ),
        ],
        toolchain_identifier = "bootstrap_toolchain",
        compiler = "gcc",
    )

bootstrap = rule(
    implementation = _bootstrap_impl,
    attrs = {
        "_gcc": attr.label(
            default = "@bootstrap//:bin/x86_64-linux-gcc",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "_gxx": attr.label(
            default = "@bootstrap//:bin/x86_64-linux-g++",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
