module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & b;
wire minterm_2 = a & c;
wire minterm_3 = c & ~d;
wire minterm_4 = b & ~c;

assign out = minterm_1 & ~d | minterm_2 & ~b | minterm_3 | minterm_4 & ~a;

endmodule