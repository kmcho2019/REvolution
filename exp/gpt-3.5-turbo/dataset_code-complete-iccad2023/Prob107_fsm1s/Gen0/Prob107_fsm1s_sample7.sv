module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out
);

  reg state_A, next_state_A;
  reg state_B, next_state_B;

  // Next state logic
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state_A <= 0;
      state_B <= 1;
    end
    else begin
      state_A <= next_state_A;
      state_B <= next_state_B;
    end
  end

  always @* begin
    // Next state logic
    next_state_A = (state_A & ~in) | (state_B & in);
    next_state_B = (state_B & ~in) | (state_A & in);

    // Output logic
    out = state_A;
  end

endmodule