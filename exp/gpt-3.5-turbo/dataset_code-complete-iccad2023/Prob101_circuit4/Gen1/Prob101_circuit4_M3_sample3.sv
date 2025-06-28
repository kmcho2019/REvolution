module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  wire cd_xor;
  
  assign cd_xor = c ^ d;
  assign q = ~cd_xor;

endmodule