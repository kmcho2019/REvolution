module A (
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module B (
  input x,
  input y,
  output z
);
  assign z = ((x & ~y) | (~x & y)) & x;
endmodule

module TopModule (
  input x,
  input y,
  output z
);

  wire a1, a2, b1, b2;

  A U1 (.x(x), .y(y), .z(a1));
  B V1 (.x(x), .y(y), .z(b1));

  A U2 (.x(x), .y(y), .z(a2));
  B V2 (.x(x), .y(y), .z(b2));

  wire or_out, and_out;

  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  assign z = or_out ^ and_out;

endmodule