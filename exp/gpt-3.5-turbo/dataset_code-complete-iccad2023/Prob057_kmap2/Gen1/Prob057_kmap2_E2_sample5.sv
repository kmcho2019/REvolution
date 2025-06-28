module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & c;
wire minterm_2 = a & b;
wire minterm_3 = c & ~d;
wire minterm_4 = b & ~a;

assign out = minterm_1 & ~b | minterm_2 & ~c | minterm_3 | minterm_4 | c & d;

endmodule