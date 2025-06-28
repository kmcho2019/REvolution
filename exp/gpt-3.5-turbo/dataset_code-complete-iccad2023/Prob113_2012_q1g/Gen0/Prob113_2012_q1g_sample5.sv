module TopModule (
  input [4:1] x,
  output logic f
);

// Function expression f(x) = x[1]*x[4] + x[3]*x[4] + (x[1] xor x[2] xor x[3])
assign f = (x[1] & x[4]) | (x[3] & x[4]) | (x[1] ^ x[2] ^ x[3]);

endmodule