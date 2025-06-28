module A(
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module B(
  input x,
  input y,
  output z
);
  assign z = (
    (x == 1 && y == 0) || 
    (x == 0 && y == 1)
  );
endmodule

module OR_gate(
  input a,
  input b,
  output z
);
  assign z = a | b;
endmodule

module AND_gate(
  input a,
  input b,
  output z
);
  assign z = a & b;
endmodule

module XOR_gate(
  input a,
  input b,
  output z
);
  assign z = a ^ b;
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1, a2, b1, b2;
  A a_inst1(.x(x), .y(y), .z(a1));
  B b_inst1(.x(x), .y(y), .z(b1));
  A a_inst2(.x(x), .y(y), .z(a2));
  B b_inst2(.x(x), .y(y), .z(b2));

  OR_gate or_inst(.a(a1), .b(b1), .z(z1));
  AND_gate and_inst(.a(a2), .b(b2), .z(z2));
  XOR_gate xor_inst(.a(z1), .b(z2), .z);
endmodule