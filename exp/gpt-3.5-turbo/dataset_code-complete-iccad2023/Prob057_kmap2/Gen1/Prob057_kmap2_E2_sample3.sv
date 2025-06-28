module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & b & ~c & d;
wire minterm_2 = a & b & c & ~d;
wire minterm_3 = a & ~b & c & ~d;
wire minterm_4 = ~a & b & c & d;

assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule