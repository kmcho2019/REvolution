module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  wire A = state[0];
  wire B = state[1];
  wire C = state[2];
  wire D = state[3];

  always @(*) begin
    next_state[0] = (A & ~in) | (C & ~in);         // next_state A
    next_state[1] = (A & in) | (B & in) | (D & in); // next_state B
    next_state[2] = (B & ~in) | (D & ~in);         // next_state C
    next_state[3] = (C & in);                       // next_state D
  end

  assign out = D;

endmodule