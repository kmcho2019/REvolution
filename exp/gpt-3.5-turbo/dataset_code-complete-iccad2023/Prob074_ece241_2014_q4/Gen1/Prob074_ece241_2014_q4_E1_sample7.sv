module TopModule (
  input clk,
  input x,
  output reg z
);

reg d_x, d_not_x; // D flip-flops input signals
reg q_xor, q_and, q_or; // D flip-flops output signals

// D flip-flop for x
always @(posedge clk)
  d_x <= x;

// D flip-flop for not x
always @(posedge clk)
  d_not_x <= ~x;

// XOR gate connection to D flip-flop
always @(posedge clk)
  q_xor <= d_x ^ q_xor;

// AND gate connection to D flip-flop
always @(posedge clk)
  q_and <= d_not_x & q_and;

// OR gate connection to D flip-flop
always @(posedge clk)
  q_or <= ~d_not_x | q_or;

// Combine outputs using NOR gate
assign z = ~(q_xor | q_and | q_or);

endmodule