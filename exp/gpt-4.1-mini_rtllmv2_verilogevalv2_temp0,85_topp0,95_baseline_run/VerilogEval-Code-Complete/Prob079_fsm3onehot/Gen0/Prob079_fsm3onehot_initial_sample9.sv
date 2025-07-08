module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // Next state logic
  always @(*) begin
    next_state = 4'b0000;
    // Next state A (0001)
    // from A if in=0 or from C if in=0
    if ((state[0] && ~in) || (state[2] && ~in))
      next_state[0] = 1'b1;
    else
      next_state[0] = 1'b0;

    // Next state B (0010)
    // from A if in=1 or from B if in=1 or from D if in=1
    if ((state[0] && in) || (state[1] && in) || (state[3] && in))
      next_state[1] = 1'b1;
    else
      next_state[1] = 1'b0;

    // Next state C (0100)
    // from B if in=0 or from D if in=0
    if ((state[1] && ~in) || (state[3] && ~in))
      next_state[2] = 1'b1;
    else
      next_state[2] = 1'b0;

    // Next state D (1000)
    // from C if in=1
    if (state[2] && in)
      next_state[3] = 1'b1;
    else
      next_state[3] = 1'b0;
  end

  // Output logic (Moore): output=1 only in state D
  assign out = state[3];

endmodule