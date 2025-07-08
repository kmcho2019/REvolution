module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // next state logic
  always @(*) begin
    next_state = 4'b0000;
    // next_state A: from A(0) or C(0)
    if ((state[0] && !in) || (state[2] && !in))
      next_state[0] = 1'b1;
    // next_state B: from A(1), B(1), or D(1)
    if ((state[0] && in) || (state[1] && in) || (state[3] && in))
      next_state[1] = 1'b1;
    // next_state C: from B(0) or D(0)
    if ((state[1] && !in) || (state[3] && !in))
      next_state[2] = 1'b1;
    // next_state D: from C(1)
    if (state[2] && in)
      next_state[3] = 1'b1;
  end

  // output logic: output is 1 only in state D
  assign out = state[3];

endmodule