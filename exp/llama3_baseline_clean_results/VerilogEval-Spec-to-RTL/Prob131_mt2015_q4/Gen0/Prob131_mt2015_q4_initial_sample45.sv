// Define Module A
module A(
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

// Define Module B
module B(
  input x,
  input y,
  output z
);
  assign z = (x == y);
endmodule

// Define the top-level module
module top(
  input x,
  input y,
  output z
);
  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

  // Instantiate Module A and Module B
  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // Connect outputs to OR and AND gates
  or or1(.a(a1_out), .b(b1_out), .z(or_out));
  and and1(.a(a2_out), .b(b2_out), .z(and_out));

  // Connect outputs of OR and AND to XOR gate
  xor xor1(.a(or_out), .b(and_out), .z(z));
endmodule

// Define OR gate
module or(
  input a,
  input b,
  output z
);
  assign z = a | b;
endmodule

// Define AND gate
module and(
  input a,
  input b,
  output z
);
  assign z = a & b;
endmodule

// Define XOR gate
module xor(
  input a,
  input b,
  output z
);
  assign z = a ^ b;
endmodule