module TopModule (
  input [4:0] a,
  input [4:0] b,
  input [4:0] c,
  input [4:0] d,
  input [4:0] e,
  input [4:0] f,
  output [7:0] w,
  output [7:0] x,
  output [7:0] y,
  output [7:0] z
);

  wire [29:0] in_concatenated;
  wire [31:0] out_concatenated;

  assign in_concatenated = {a, b, c, d, e, f}; // Concatenate input vectors

  assign out_concatenated = {in_concatenated, 2'b01}; // Append LSBs with '01'

  assign w = out_concatenated[7:0];
  assign x = out_concatenated[15:8];
  assign y = out_concatenated[23:16];
  assign z = out_concatenated[31:24];

endmodule