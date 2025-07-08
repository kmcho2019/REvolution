module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);

  // Calculate the starting bit of the selected 4-bit slice
  wire [9:0] start_bit = sel * 4;

  // Assign the output to the selected 4-bit slice
  assign out = in[start_bit +: 4];

endmodule