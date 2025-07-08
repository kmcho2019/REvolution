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
    next_state[0] = (A & ~in) | (C & ~in);         // Next A
    next_state[1] = (A & in) | (B & in) | (D & in); // Next B
    next_state[2] = (B & ~in) | (D & ~in);          // Next C
    next_state[3] = C & in;                          // Next D
  end

  assign out = D;

endmodule