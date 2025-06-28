module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & c;
wire minterm_2 = ~a & b;
wire minterm_3 = c & d;

assign out = (minterm_1 & ~d) | (minterm_2 & ~c) | (minterm_1 & ~b) | (minterm_1 & minterm_3);

endmodule