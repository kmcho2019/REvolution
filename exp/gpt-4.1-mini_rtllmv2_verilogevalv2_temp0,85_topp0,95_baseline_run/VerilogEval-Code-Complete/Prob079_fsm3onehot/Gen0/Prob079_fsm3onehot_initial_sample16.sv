module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  // State bits for clarity
  wire A = state[0];
  wire B = state[1];
  wire C = state[2];
  wire D = state[3];

  // Next state logic
  always @(*) begin
    next_state[0] = (A & ~in) | (C & ~in);     // A next state
    next_state[1] = (A & in)  | (B & in) | (D & in); // B next state
    next_state[2] = (B & ~in) | (D & ~in);     // C next state
    next_state[3] = (C & in);                   // D next state
  end

  // Output logic: out = 1 only in D
  assign out = D;

endmodule