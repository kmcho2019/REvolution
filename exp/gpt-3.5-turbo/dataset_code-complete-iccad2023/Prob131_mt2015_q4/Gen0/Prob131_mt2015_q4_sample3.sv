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
  output reg z
);
  always @(*)
    case({x, y})
      2'b00: z = 1;
      2'b01: z = 0;
      2'b10: z = 0;
      2'b11: z = 1;
    endcase
endmodule

module TopModule (
  input x,
  input y,
  output z
);
  wire a1, a2, b1, b2, a1b1_or, a2b2_and;
  
  A a1_inst (.x(x), .y(y), .z(a1));
  B b1_inst (.x(x), .y(y), .z(b1));
  A a2_inst (.x(x), .y(y), .z(a2));
  B b2_inst (.x(x), .y(y), .z(b2));

  assign a1b1_or = a1 | b1;
  assign a2b2_and = a2 & b2;

  assign z = a1b1_or ^ a2b2_and;
endmodule