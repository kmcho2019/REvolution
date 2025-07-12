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

  // Default next state assignments
  always @(*) begin
    // Default: no next state asserted
    S_next    = 1'b0;
    S1_next   = 1'b0;
    B3_next   = 1'b0;
    Count_next= 1'b0;
    Wait_next = 1'b0;

    case(1'b1)  // one-hot priority encoding
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
          // S11 next state is not output requested, so no output assigned here
          S1_next = 1'b0;  // explicitly cleared for clarity
      end

      S11: begin
        if (d == 1'b0)
          ; // Next state S110 not output requested
        else
          ; // Stay in S11, no outputs requested for next state
      end

      S110: begin
        if (d == 1'b0)
          S_next = 1'b1;
        else
          // next state B0 not requested output signals, no assignment here
          ;
      end

      B0: begin
        // Always next to B1, no outputs requested here
      end

      B1: begin
        // Always next to B2, no outputs requested here
      end

      B2: begin
        // Always next to B3, so assert B3_next
        B3_next = 1'b1;
      end

      B3: begin
        // Always next to Count
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
        // No next state asserted if no current state matched
      end
    endcase
  end

  // Moore outputs from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule