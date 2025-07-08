module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // Next state logic
  always @(*) begin
    next_state = 4'b0000; // default no state active

    // next_state A (bit 0)
    if ((state[0] && ~in) || (state[2] && ~in))
      next_state[0] = 1'b1;
    else
      next_state[0] = 1'b0;

    // next_state B (bit 1)
    if ((state[0] && in) || state[1] || (state[3] && in))
      next_state[1] = 1'b1;
    else
      next_state[1] = 1'b0;

    // next_state C (bit 2)
    if ((state[1] && ~in) || (state[3] && ~in))
      next_state[2] = 1'b1;
    else
      next_state[2] = 1'b0;

    // next_state D (bit 3)
    if (state[2] && in)
      next_state[3] = 1'b1;
    else
      next_state[3] = 1'b0;
  end

  // Output logic (Moore output)
  assign out = state[3];

endmodule