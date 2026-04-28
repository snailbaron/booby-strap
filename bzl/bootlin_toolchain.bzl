def _bootlin_toolchain_impl(repository_ctx):
    # type: (repository_ctx) -> None
    result = repository_ctx.download_and_extract(
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
        integrity = repository_ctx.attr.integrity,
        strip_prefix = repository_ctx.attr.strip_prefix,
    )
    if not result.success:
        fail("failed to download Bootlin toolchain")

    if not repository_ctx.attr.sha256 and not repository_ctx.attr.integrity:
        print("sha256:", result.sha256)
        print("integrity:", result.integrity)

    build_file_content = repository_ctx.read(repository_ctx.attr._build_file)
    repository_ctx.file("BUILD.bazel", content = build_file_content)

    result = repository_ctx.execute(["./relocate-sdk.sh"], timeout = 30)
    if result.return_code != 0:
        fail("""\
./relocate-sdk.sh command failed:
stdout:
{}
stderr:
{}
""".format(result.stdout, result.stderr))

bootlin_toolchain = repository_rule(
    implementation = _bootlin_toolchain_impl,
    attrs = {
        "url": attr.string(
            mandatory = True,
        ),
        "sha256": attr.string(),
        "integrity": attr.string(),
        "strip_prefix": attr.string(),
        "_build_file": attr.label(
            default = "//bzl:bootlin_toolchain.BUILD.bazel",
            allow_single_file = True,
        ),
    },
)
