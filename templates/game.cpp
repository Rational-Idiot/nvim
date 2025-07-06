#include <iostream>
#include <string>
#include <vector>

using namespace std;

class MyClass {
private:
  string name;
  int value;

public:
  // Constructor
  MyClass(const string &name, int value) : name(name), value(value) {}

  // Getter
  string getName() const { return name; }

  // Setter
  void setName(const string &newName) { name = newName; }

  void display() const {
    cout << "Name: " << name << ", Value: " << value << endl;
  }
};

int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);

  // cursor
  MyClass obj("Example", 42);
  obj.display();

  return 0;
}
