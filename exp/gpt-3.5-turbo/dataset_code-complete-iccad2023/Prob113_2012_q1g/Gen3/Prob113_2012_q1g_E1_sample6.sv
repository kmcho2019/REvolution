module TopModule (
  input [3:0] x,
  output logic f
);

  // Define a lookup table based on the given Karnaugh map
  // Each entry corresponds to the output value for the specific input combination
  logic [15:0] lut = 16'b1001000000110111;

  // Use bitwise manipulation to extract the index from the input x
  logic [3:0] index = {x[3], x[2], x[1], x[0]};

  // Access the corresponding output value from the lookup table using the index
  assign f = lut[index];

endmodule