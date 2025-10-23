module TopModule(
  input  a,
  input  b,
  input  c,
  input  d,
  output q
);

always @(*)
  case ({a, b, c, d})
    4'b0000, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1111: q = 1'b1;
    default: q = 1'b0;
  endcase

endmodule