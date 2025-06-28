module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  // Define minterms based on the Karnaugh map
  wire minterm_1 = a & b & c & ~d;
  wire minterm_2 = a & c & d;
  wire minterm_3 = ~a & b & ~c;
  wire minterm_4 = a & b & ~c;
  
  // Implement the final output expression using minterms
  assign out = minterm_1 | minterm_2 | minterm_3 | minterm_4;

endmodule