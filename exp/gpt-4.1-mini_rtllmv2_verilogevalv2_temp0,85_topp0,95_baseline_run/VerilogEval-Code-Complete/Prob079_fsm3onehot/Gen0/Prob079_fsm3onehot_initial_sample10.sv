module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  always @(*) begin
    // Default next_state to 0
    next_state = 4'b0000;
    // Next state A (0001) when:
    // From A with in=0 -> next A
    // From C with in=0 -> next A
    if ((state[0] && ~in) || (state[2] && ~in))
      next_state[0] = 1'b1;

    // Next state B (0010) when:
    // From A with in=1 -> next B
    // From B with in=1 -> next B
    // From D with in=1 -> next B
    if ((state[0] && in) || (state[1] && in) || (state[3] && in))
      next_state[1] = 1'b1;

    // Next state C (0100) when:
    // From B with in=0 -> next C
    // From D with in=0 -> next C
    if ((state[1] && ~in) || (state[3] && ~in))
      next_state[2] = 1'b1;

    // Next state D (1000) when:
    // From C with in=1 -> next D
    if (state[2] && in)
      next_state[3] = 1'b1;
  end

  // Output logic: out=1 only in state D (state[3])
  assign out = state[3];

endmodule