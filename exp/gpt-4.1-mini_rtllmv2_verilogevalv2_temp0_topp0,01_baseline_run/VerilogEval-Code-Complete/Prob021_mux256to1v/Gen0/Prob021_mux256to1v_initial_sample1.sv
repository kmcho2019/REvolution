module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);
  // Calculate the starting bit index for the selected 4-bit input
  wire [9:0] start_bit = sel * 4;

  // Assign the 4-bit output by slicing the input vector
  assign out = in[start_bit +: 4];

endmodule