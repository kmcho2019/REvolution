module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & c; // Grouping cells 01, 00
wire minterm_2 = c & d; // Grouping cells 11, 10
wire minterm_3 = b & c; // Grouping cells 11, 01
wire minterm_4 = a & b; // Grouping cells 01, 00, 10

assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule