module TopModule (
  input [4:1] x,
  output logic f
);

  // Simplified logical expression using the minimized form based on the K-map
  assign f = x[1] ^ x[2] ^ !x[3] ^ x[4] ^ (x[1] & !x[2] & !x[4]) ^ (!x[1] & x[2] & x[3]) ^ (x[1] & x[2] & x[3]) ^ (x[1] & !x[3] & !x[4]);

endmodule