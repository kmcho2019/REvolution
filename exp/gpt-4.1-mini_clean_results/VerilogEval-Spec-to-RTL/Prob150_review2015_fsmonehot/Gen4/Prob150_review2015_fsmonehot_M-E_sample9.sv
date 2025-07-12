module TopModule(
  input  d,
  input  done_counting,
  input  ack,
  input  [9:0] state,    // one-hot encoded
  output reg B3_next,
  output reg S_next,
  output reg S1_next,
  output reg Count_next,
  output reg Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // Decode current state one-hot bits
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

  // Next state logic for requested states
  always @(*) begin
    // Default assignments
    S_next     = 1'b0;
    S1_next    = 1'b0;
    B3_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;

    // State S transitions
    if (S) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        S1_next = 1'b1;
    end

    // State S1 transitions
    else if (S1) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        // S11 is not a requested next state output, so no B3/S/S1/Count/Wait asserted here
        // Nothing to assign for S11_next output (not asked)
        ;
    end

    // State S11 transitions
    else if (S11) begin
      if (d == 1'b0)
        // next state is S110, not requested output
        ;
      else
        // next state remains S11, no next state outputs requested here
        ;
    end

    // State S110 transitions
    else if (S110) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        // next state B0, no direct outputs requested for B0_next
        ;
    end

    // State B0 transitions (always next to B1, no outputs to assert here)
    else if (B0) begin
      // no requested next state outputs here (B1 is not requested)
    end

    // State B1 transitions (always next to B2, no outputs to assert here)
    else if (B1) begin
      // no requested next state outputs here (B2 is not requested)
    end

    // State B2 transitions (always next to B3)
    else if (B2) begin
      B3_next = 1'b1;
    end

    // State B3 transitions (always next to Count)
    else if (B3) begin
      Count_next = 1'b1;
    end

    // State Count transitions
    else if (Count) begin
      if (done_counting == 1'b0)
        Count_next = 1'b1;  // stay in Count
      else
        Wait_next = 1'b1;
    end

    // State Wait transitions
    else if (Wait) begin
      if (ack == 1'b0)
        Wait_next = 1'b1;
      else
        S_next = 1'b1;
    end

  end

  // Moore outputs depend on current state only
  assign shift_ena = B0 | B1 | B2 | B3;
  assign done      = Wait;
  assign counting  = Count;

endmodule