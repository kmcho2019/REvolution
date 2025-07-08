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
    // Next state bits initialization
    next_state = 4'b0000;

    // next_state[0] = A_next
    // A_next = (A & ~in) | (C & ~in);
    // From table, A_next = 1 when (state=A and in=0) or (state=C and in=0)
    next_state[0] = (A & ~in) | (C & ~in);

    // next_state[1] = B_next
    // B_next = (A & in) | (B & in) | (D & in);
    // From table, B_next = 1 when (state=A and in=1) or (state=B and in=1) or (state=D and in=1)
    next_state[1] = (A & in) | (B & in) | (D & in);

    // next_state[2] = C_next
    // C_next = (B & ~in) | (D & ~in);
    // From table, C_next = 1 when (state=B and in=0) or (state=D and in=0)
    next_state[2] = (B & ~in) | (D & ~in);

    // next_state[3] = D_next
    // D_next = (C & in);
    // From table, D_next = 1 when (state=C and in=1)
    next_state[3] = (C & in);
  end

  // Output logic: out=1 only in state D
  assign out = D;

endmodule