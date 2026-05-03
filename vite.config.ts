import { defineConfig } from "vite-plus";

export default defineConfig({
  staged: { "*": "vp check --fix" },
  pack: {
    clean: true,
    dts: {
      tsgo: true,
    },
    entry: ["./src/*.ts", "!./src/**/*.test.ts"],
    exports: {
      devExports: true,
    },
    fixedExtension: false,
    format: "esm",
    minify: "dce-only",
    nodeProtocol: true,
    outDir: "dist",
    publint: true,
    sourcemap: false,
    treeshake: true,
    unused: true,
  },
  lint: {
    options: {
      typeAware: true,
      typeCheck: true,
    },
  },
  fmt: {},
});
