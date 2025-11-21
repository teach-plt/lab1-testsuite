#include <iostream>

int main() {
  int i = 2;
  while (true)
    if (true)
      if (i == 2)
        std::cout << "if: " << i << std::endl;
      else
        std::cout << "else: " << i << std::endl;
  // the else is associated to the inner if
}
