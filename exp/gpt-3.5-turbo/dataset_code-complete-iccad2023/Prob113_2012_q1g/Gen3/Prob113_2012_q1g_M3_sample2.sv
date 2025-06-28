module TopModule (
  input [3:0] x,
  output logic f
);

  assign f = 
    // Bitwise operations to match the input combinations to the corresponding output values based on the Karnaugh map
    ((x == 4'b0000) | (x == 4'b1101) | (x == 4'b1111) | (x == 4'b0010));

endmodule