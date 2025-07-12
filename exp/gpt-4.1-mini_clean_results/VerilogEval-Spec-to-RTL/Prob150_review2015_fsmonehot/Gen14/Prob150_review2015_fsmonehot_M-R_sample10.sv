module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoding of current state
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current states
  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count= state[8];
  wire Wait = state[9];

  // Outputs directly from current states (Moore)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

  always @(*) begin
    // Default next states all deasserted
    S_next = 1'b0;
    S1_next = 1'b0;
    B3_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;

    case (1'b1) // one-hot current state decoder
      S: begin
        if (d == 1'b0)
          S_next = 1'b1;
        else
          S1_next = 1'b1;
      end

      S1: begin
        if (d == 1'b0)
          S_next = 1'b1;
        else
          // next state is S11, which is not requested as output signal
          // so no output signal is asserted here.
          // (Nothing to assert means no outputs for S11_next)
          ;
      end

      S11: begin
        if (d == 1'b0)
          // next state S110, no output signal asserted
          ;
        else
          // stay in S11 (no next output signal asserted)
          ;
      end

      S110: begin
        if (d == 1'b0)
          S_next = 1'b1;
        else
          // next state B0, no output signals required for B0_next
          ;
      end

      B0: begin
        // next state always B1, no outputs for B1_next
      end

      B1: begin
        // next state always B2, no outputs for B2_next
      end

      B2: begin
        // next state always B3
        B3_next = 1'b1;
      end

      B3: begin
        // next state always Count
        Count_next = 1'b1;
      end

      Count: begin
        if (done_counting == 1'b0)
          Count_next = 1'b1;
        else
          Wait_next = 1'b1;
      end

      Wait: begin
        if (ack == 1'b0)
          Wait_next = 1'b1;
        else
          S_next = 1'b1;
      end

      default: begin
        // Should not occur if one-hot input is valid
        // Default to S state
        S_next = 1'b1;
      end
    endcase
  end

endmodule