int main() {
  int x = 0;
  x = 0 * ++x;
  x = 0 * --x;
  x = 0 * x++;
  x = 0 * x--;
  return 0;
}
