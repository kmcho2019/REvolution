module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded as (S=bit0,... Wait=bit9)
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current one-hot states
  wire S     = state[0];
  wire S1    = state[1];
  wire S11   = state[2];
  wire S110  = state[3];
  wire B0    = state[4];
  wire B1    = state[5];
  wire B2    = state[6];
  wire B3    = state[7];
  wire Count = state[8];
  wire Wait  = state[9];

  // Initialize next-state outputs to 0 by default
  always @(*) begin
    B3_next  = 1'b0;
    S_next   = 1'b0;
    S1_next  = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;

    case (1'b1)  // One-hot state decode by priority
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
          // next state S11 not an output signal, no assignment needed here
          ; 
      end

      S11: begin
        if (d == 1'b0)
          ; // next state S110 not an output signal, no assignment needed
        else
          ; // stays in S11; no next-state output signal required
      end

      S110: begin
        if (d == 1'b0)
          S_next = 1'b1;
        else
          ; // next state B0 not an output signal
      end

      B0: begin
        // Always go to B1
        // B1 not an output signal here
      end

      B1: begin
        // Always go to B2
      end

      B2: begin
        // Always go to B3
        B3_next = 1'b1;
      end

      B3: begin
        // Always go to Count
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
        // Should never occur if one-hot encoding is guaranteed
      end
    endcase
  end

  // Outputs decoded directly from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule