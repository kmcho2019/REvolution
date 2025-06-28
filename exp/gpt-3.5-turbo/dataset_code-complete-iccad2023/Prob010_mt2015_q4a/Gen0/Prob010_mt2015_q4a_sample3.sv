module TopModule (
  input x,
  input y,
  output z
);
  
  wire x_xor_y;
  
  assign x_xor_y = x ^ y;
  assign z = x_xor_y & x;

endmodule