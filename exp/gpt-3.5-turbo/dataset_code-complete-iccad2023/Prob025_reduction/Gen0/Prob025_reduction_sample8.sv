module TopModule (
  input [7:0] in,
  output parity
);

wire [7:0] xor_input;
wire xor_output;

// XOR all 8 data bits
assign xor_input = in;
assign xor_output = ^xor_input;

// Parity bit is the result of XOR
assign parity = xor_output;
endmodule