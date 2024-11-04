#include <exception>

int main()
{
  return true ? throw std::exception() : 0;
}
