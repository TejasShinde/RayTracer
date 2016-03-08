class Stack{
  int top;
  int[] stack;
  
  Stack() {
    this.top = -1;
    stack = new int[1000];
  }
  
  void push(int m) {
    top++;
    stack[top] = m;
  }
  
  int pop() {
    top--;
    return stack[top+1];
  }
  
  boolean empty() {
    if(this.top < 0) return true;
    else return false;
  }

}

