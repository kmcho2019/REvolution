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

  wire [31:0] concat_vec;
  
  // Concatenate inputs and append two 1 bits at LSB
  assign concat_vec = {a, b, c, d, e, f, 2'b11};
  
  // Split into four 8-bit outputs, MSB to w, LSB to z
  assign w = concat_vec[31:24];
  assign x = concat_vec[23:16];
  assign y = concat_vec[15:8];
  assign z = concat_vec[7:0];

endmodule