module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = a & c; // Group 1s in the Karnaugh map (a=0, c=0 and a=1, c=1)
wire minterm_2 = c & d; // Group 1s in the Karnaugh map (c=0, d=1 and c=1, d=0)
wire minterm_3 = ~a & ~b; // Group 1s in the Karnaugh map (a=0, b=0)
wire minterm_4 = b & d; // Group 1s in the Karnaugh map (b=1, d=0)

assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule