module TopModule (
  input [7:0] in,
  output parity
);

  wire [2:0] xor_chain;
  
  assign xor_chain[0] = in[0] ^ in[1];
  assign xor_chain[1] = xor_chain[0] ^ in[2];
  assign xor_chain[2] = xor_chain[1] ^ in[3];
  // Continue this pattern for all 8 bits
  
  assign parity = xor_chain[2];

endmodule