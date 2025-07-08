module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // next_state logic
  always @(*) begin
    next_state[0] = (state[0] & ~in) | (state[2] & ~in);           // A
    next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in); // B
    next_state[2] = (state[1] & ~in) | (state[3] & ~in);           // C
    next_state[3] = state[2] & in;                                 // D
  end

  // output logic
  assign out = state[3];

endmodule