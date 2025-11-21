#include <iostream>

int main() {
  for (int i = 0; i < 5; ++i)
    if (true)
      if (i == 2)
        std::cout << "if: " << i << std::endl;
      else
        std::cout << "else: " << i << std::endl;
  // the else is assiocaiated to the inner if
}
