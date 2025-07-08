module TopModule (
  input [7:0] in,
  output parity
);
  assign parity = ^in; // XOR reduction operator over all bits of input
endmodule