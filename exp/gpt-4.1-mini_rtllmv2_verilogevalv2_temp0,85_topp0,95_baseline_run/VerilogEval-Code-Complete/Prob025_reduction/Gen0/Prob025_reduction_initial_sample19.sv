module TopModule (
  input [7:0] in,
  output parity
);
  // even parity bit is XOR of all input bits
  assign parity = ^in;
endmodule