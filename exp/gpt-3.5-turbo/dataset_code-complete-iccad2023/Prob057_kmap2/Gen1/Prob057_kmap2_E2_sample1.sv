module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

wire minterm_1 = b & ~c & d;  // Simplified minterm from Karnaugh map for 0101
wire minterm_2 = b & c & ~d;  // Simplified minterm from Karnaugh map for 0011
wire minterm_3 = a & c & d;   // Simplified minterm from Karnaugh map for 1111
wire minterm_4 = a & b & ~c;  // Simplified minterm from Karnaugh map for 1000

assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule