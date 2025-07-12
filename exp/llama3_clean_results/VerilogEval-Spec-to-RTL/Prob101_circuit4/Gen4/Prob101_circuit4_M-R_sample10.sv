module TopModule(
  input  a,
  input  b,
  input  c,
  input  d,
  output q
);

  // Calculate b or c
  wire bc_or;
  assign bc_or = b || c;

  // Use the result of b or c as q, since a's state doesn't change the outcome when b or c is 1
  assign q = bc_or;

endmodule