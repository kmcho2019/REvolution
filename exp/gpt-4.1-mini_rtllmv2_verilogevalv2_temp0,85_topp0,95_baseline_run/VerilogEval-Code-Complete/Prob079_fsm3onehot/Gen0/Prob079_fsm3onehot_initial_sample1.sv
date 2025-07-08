module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // next_state[0] = A
  wire A_next = (state[0] & ~in) | (state[2] & ~in);
  // next_state[1] = B
  wire B_next = (state[0] & in) | (state[1] & in) | (state[3] & in);
  // next_state[2] = C
  wire C_next = (state[1] & ~in) | (state[3] & ~in);
  // next_state[3] = D
  wire D_next = state[2] & in;

  always @(*) begin
    next_state = 4'b0000;
    next_state[0] = A_next;
    next_state[1] = B_next;
    next_state[2] = C_next;
    next_state[3] = D_next;
  end

  // output logic: 1 only when in state D (state[3])
  assign out = state[3];

endmodule