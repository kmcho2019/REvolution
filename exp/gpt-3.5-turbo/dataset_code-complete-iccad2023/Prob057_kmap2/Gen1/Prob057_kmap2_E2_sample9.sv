module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = ~b & c | a & b & ~c;
wire minterm_2 = a & d | ~a & c;
wire minterm_3 = ~a & b | c & d;

assign out = minterm_1 | minterm_2 | minterm_3;

endmodule