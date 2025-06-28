module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & c;
wire minterm_2 = b & c;
wire minterm_3 = a & ~d;
wire minterm_4 = c & d;

assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule