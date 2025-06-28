module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  
  assign q = d & ((a ^ b) ^ c); // XOR operation to count number of high inputs
  
endmodule