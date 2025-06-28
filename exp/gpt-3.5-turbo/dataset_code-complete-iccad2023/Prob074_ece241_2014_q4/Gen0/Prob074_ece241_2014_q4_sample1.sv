module TopModule (
  input clk,
  input x,
  output z
);

  reg flop1, flop2, flop3;

  always @(posedge clk) begin
    // Update D flip-flop values based on input x
    flop1 <= x ^ flop1; // XOR gate
    flop2 <= x & ~flop2; // AND gate
    flop3 <= x | ~flop3; // OR gate
  end

  assign z = ~(flop1 | flop2 | flop3); // Three-input NOR gate output

endmodule