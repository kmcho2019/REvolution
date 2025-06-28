module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire term_1 = ~b & c;
wire term_2 = a & d;
wire term_3 = b & ~c;
wire term_4 = a & (b | c);

assign out = term_1 | term_2 | term_3 | term_4;

endmodule