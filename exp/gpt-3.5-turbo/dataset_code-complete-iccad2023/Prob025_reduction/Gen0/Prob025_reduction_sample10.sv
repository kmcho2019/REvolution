module TopModule (
  input [7:0] in,
  output parity
);

wire [2:0] internal_parity;
assign internal_parity[0] = in[0] ^ in[1];
assign internal_parity[1] = internal_parity[0] ^ in[2];
assign internal_parity[2] = internal_parity[1] ^ in[3];

assign parity = internal_parity[2] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule