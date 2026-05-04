import { defineConfig } from 'vite-plus';

export default defineConfig({
  // @keep-sorted
  pack: {
    clean: true,
    define: {
      'import.meta.vitest': 'undefined',
    },
    dts: {
      tsgo: true,
    },
    entry: ['./src/*.ts', '!./src/**/*.test.ts'],
    exports: {
      devExports: true,
    },
    fixedExtension: false,
    format: 'esm',
    minify: 'dce-only',
    nodeProtocol: true,
    outDir: 'dist',
    publint: true,
    sourcemap: false,
    treeshake: true,
    unused: true,
  },
  lint: {
    plugins: ['eslint', 'import', 'node', 'oxc', 'promise', 'unicorn', 'vitest', 'typescript'],
    jsPlugins: ['eslint-plugin-command', 'eslint-plugin-security'],
    categories: {
      correctness: 'error',
      suspicious: 'error',
      perf: 'error',
      restriction: 'error',
    },
    env: {
      builtin: true,
    },
    options: {
      typeAware: true,
      typeCheck: true,
    },
    // @keep-sorted
    rules: {
      'command/command': 'error',
      'import/no-default-export': 'off',
      'node/no-process-env': 'off',
      'security/detect-bidi-characters': 'warn',
      'security/detect-buffer-noassert': 'warn',
      'security/detect-child-process': 'warn',
      'security/detect-disable-mustache-escape': 'warn',
      'security/detect-eval-with-expression': 'warn',
      'security/detect-new-buffer': 'warn',
      'security/detect-no-csrf-before-method-override': 'warn',
      'security/detect-non-literal-fs-filename': 'warn',
      'security/detect-non-literal-regexp': 'warn',
      'security/detect-non-literal-require': 'warn',
      'security/detect-object-injection': 'warn',
      'security/detect-possible-timing-attacks': 'warn',
      'security/detect-pseudoRandomBytes': 'warn',
      'security/detect-unsafe-regex': 'warn',
      'typescript/ban-ts-comment': 'error',
      'typescript/consistent-type-definitions': 'off',
      'typescript/explicit-function-return-type': 'off',
      'typescript/explicit-module-boundary-types': 'off',
      'typescript/no-misused-promises': 'error',
      'typescript/no-unnecessary-condition': 'warn',
      'typescript/no-unnecessary-type-assertion': 'warn',
      'typescript/no-unsafe-argument': 'error',
      'typescript/no-unsafe-assignment': 'error',
      'typescript/no-unsafe-call': 'error',
      'typescript/no-unsafe-function-type': 'error',
      'typescript/no-unsafe-member-access': 'error',
      'typescript/no-unsafe-return': 'error',
      'typescript/prefer-nullish-coalescing': 'warn',
      'typescript/prefer-optional-chain': 'warn',
      'typescript/switch-exhaustiveness-check': 'error',
    },
  },
  // @keep-sorted
  fmt: {
    semi: true,
    singleQuote: true,
    sortImports: {
      groups: [
        ['type-builtin', 'value-builtin'],
        ['type-external', 'type-internal', 'value-external', 'value-internal'],
        [
          'type-index',
          'type-parent',
          'type-sibling',
          'value-index',
          'value-parent',
          'value-sibling',
        ],
        ['unknown'],
      ],
      newlinesBetween: true,
      order: 'asc',
    },
    sortPackageJson: true,
    trailingComma: 'all',
  },
  // @keep-sorted
  test: {
    include: ['src/**/*.test.{ts,tsx}'],
    includeSource: ['src/**/*.{ts,tsx}'],
    passWithNoTests: true,
    reporters:
      process.env['GITHUB_ACTIONS'] === 'true' ? ['default', 'github-actions'] : ['default'],
    watch: false,
  },
});
