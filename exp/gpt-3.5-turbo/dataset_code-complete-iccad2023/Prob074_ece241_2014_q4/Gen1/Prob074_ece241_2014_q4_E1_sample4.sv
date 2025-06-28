module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] d_ff; // D flip-flops for storing outputs

// XOR gate
assign d_ff[0] = x ^ d_ff[0];
// AND gate
assign d_ff[1] = ~(x & ~d_ff[1]);
// OR gate
assign d_ff[2] = ~(x | ~d_ff[2]);

// Three-input NOR gate to combine outputs
assign z = ~(d_ff[0] | d_ff[1] | d_ff[2]);

endmodule