module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  reg state_reg;

  wire next_state;

  // Next state logic
  assign next_state = (state_reg & ~a) | (~state_reg & (a ^ b));

  // State flip-flop
  always @(posedge clk) begin
    state_reg <= next_state;
  end

  // Outputs
  assign state = state_reg;
  always @(*) begin
    q = state_reg;
  end

endmodule