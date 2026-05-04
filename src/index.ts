export function fn() {
  return 'Hello, tsdown!';
}

if (import.meta.vitest) {
  const { expect, test } = import.meta.vitest;

  test('fn', () => {
    expect(fn()).toBe('Hello, tsdown!');
  });
}
