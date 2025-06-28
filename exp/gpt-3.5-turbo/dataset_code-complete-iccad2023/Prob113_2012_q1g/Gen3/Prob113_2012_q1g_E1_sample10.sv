module TopModule (
  input [3:0] x,
  output logic f
);

  // Define a 2D array to represent the function f based on the Karnaugh map
  logic lut [3:0][3:0] = '{ '{1'b1, 1'b0, 1'b0, 1'b1},
                            '{1'b0, 1'b0, 1'b0, 1'b0},
                            '{1'b1, 1'b1, 1'b1, 1'b0},
                            '{1'b1, 1'b1, 1'b0, 1'b1} };

  // Use the input x to index the Look-Up Table to determine the output f
  assign f = lut[x[3:2]][x[1:0]];

endmodule