module TopModule (
  input [3:0] x,
  output logic f
);

  wire [3:0] index; // Convert input x into index for decoder

  // Bitwise AND operations to obtain index
  assign index[0] = x[0] & x[1];
  assign index[1] = ~x[0] & x[1];
  assign index[2] = x[0] & ~x[1];
  assign index[3] = x[0] & x[1];

  // Decode the index using a 4-to-16 decoder
  assign f = |(index);

endmodule