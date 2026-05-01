load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
)
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
            action_config(
                action_name = ACTION_NAMES.cpp_link_executable,
                enabled = True,
                tools = [tool(tool = ctx.file._gxx)],
            ),
            action_config(
                action_name = ACTION_NAMES.cpp_link_dynamic_library,
                enabled = True,
                tools = [tool(tool = ctx.file._gxx)],
            ),
            action_config(
                action_name = ACTION_NAMES.cpp_link_nodeps_dynamic_library,
                enabled = True,
                tools = [tool(tool = ctx.file._gxx)],
            ),
            action_config(
                action_name = ACTION_NAMES.cpp_link_static_library,
                enabled = True,
                tools = [tool(tool = ctx.file._gxx)],
            ),
        ],
        features = [
            feature(
                name = "default-std",
                enabled = True,
                flag_sets = [
                    flag_set(
                        actions = [ACTION_NAMES.cpp_compile],
                        flag_groups = [flag_group(flags = ["-std=c++26"])],
                    ),
                    flag_set(
                        actions = [ACTION_NAMES.c_compile],
                        flag_groups = [flag_group(flags = ["-std=c99"])],
                    ),
                ],
            ),
            feature(
                name = "defaults",
                enabled = True,
                flag_sets = [
                    flag_set(
                        actions = [
                            ACTION_NAMES.c_compile,
                            ACTION_NAMES.cpp_compile,
                        ],
                        flag_groups = [flag_group(flags = ["-std=c++26"])],
                    ),
                    flag_set(
                        actions = [
                            ACTION_NAMES.c_compile,
                            ACTION_NAMES.cpp_compile,
                        ],
                        flag_groups = [flag_group(flags = [
                            "-no-canonical-prefixes",
                        ])],
                    ),
                ],
            ),
            feature(
                name = "debug",
                flag_sets = [
                    flag_set(
                        actions = [
                            ACTION_NAMES.c_compile,
                            ACTION_NAMES.cpp_compile,
                        ],
                        flag_groups = [flag_group(flags = ["--verbose"])],
                    ),
                ],
            ),
        ],
        toolchain_identifier = "bootstrap_toolchain",
        compiler = "gcc",
        cxx_builtin_include_directories = [
            f.path
            for f in ctx.files._builtin_include_directories
        ],
    )

bootstrap = rule(
    implementation = _bootstrap_impl,
    attrs = {
        "_builtin_include_directories": attr.label(
            default = "@bootstrap//:builtin_include_directories",
            allow_files = True,
        ),
        "_gcc": attr.label(
            default = "@bootstrap//:bin/x86_64-linux-gcc.br_real",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "_gxx": attr.label(
            default = "@bootstrap//:bin/x86_64-linux-g++.br_real",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "_ld": attr.label(
            default = "@bootstrap//:bin/x86_64-linux-ld",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
