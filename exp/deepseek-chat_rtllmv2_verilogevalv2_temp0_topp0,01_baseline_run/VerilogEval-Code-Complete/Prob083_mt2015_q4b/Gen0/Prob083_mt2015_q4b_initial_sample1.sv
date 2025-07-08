module TopModule (
  input x,
  input y,
  output z
);
  assign z = ~(x ^ y); // XNOR operation
  // Alternatively: assign z = (x == y);
endmodule