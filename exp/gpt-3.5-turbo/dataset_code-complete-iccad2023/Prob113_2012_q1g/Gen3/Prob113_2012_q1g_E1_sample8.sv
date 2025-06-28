module TopModule (
  input [3:0] x,
  output logic f
);

  // Implement the function f using bitwise AND and OR operations with masks
  assign f = 
    // Minterm 1: x[1]'x[2]x[4]
    ((~x[1] & x[2] & x[4]) |
    // Minterm 2: x[1]x[4]
    (x[1] & x[4]) |
    // Minterm 3: x[2]'x[3]
    (~x[2] & ~x[3]) |
    // Minterm 4: x[1]'x[2]'x[4]
    (~x[1] & ~x[2] & x[4]));

endmodule