module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,   // one-hot encoding of current state
    output reg   B3_next,
    output reg   S_next,
    output reg   S1_next,
    output reg   Count_next,
    output reg   Wait_next,
    output reg   done,
    output reg   counting,
    output reg   shift_ena
);

  // One-hot state encoding constants for readability
  localparam [9:0]
    S    = 10'b0000000001,
    S1   = 10'b0000000010,
    S11  = 10'b0000000100,
    S110 = 10'b0000001000,
    B0   = 10'b0000010000,
    B1   = 10'b0000100000,
    B2   = 10'b0001000000,
    B3   = 10'b0010000000,
    Count= 10'b0100000000,
    Wait = 10'b1000000000;

  always @(*) begin
    // Defaults for next states and outputs
    B3_next    = 1'b0;
    S_next     = 1'b0;
    S1_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;
    done       = 1'b0;
    counting   = 1'b0;
    shift_ena  = 1'b0;

    casez(state)
      S: begin
        if (d == 1'b0) S_next = 1'b1;
        else           S1_next = 1'b1;
      end
      S1: begin
        if (d == 1'b0) S_next = 1'b1;
        else           S1_next = 1'b1 << 1; // S11 is next to S1, but better to use explicit constant below
        // Instead of shift left which is ambiguous for one-hot, assign directly:
        S1_next = 1'b0;
        if(d == 1'b0) S_next = 1'b1;
        else         S1_next = 1'b0; // Will fix below by explicit assignment
      end
      S11: begin
        if (d == 1'b0) begin
          // Next state: S110
          // S110 is bit 3
          S1_next = 1'b0;
          S_next = 1'b0;
          Count_next = 1'b0;
          Wait_next = 1'b0;
          B3_next = 1'b0;
          S_next = 1'b0;
          // Use dedicated signals below
        end
        else begin
          // S11 stays
          S1_next = 1'b0;
          S_next = 1'b0;
          B3_next = 1'b0;
          Count_next = 1'b0;
          Wait_next = 1'b0;
          // We'll fix below with explicit assignment
        end
      end
      S110: begin
        if (d == 1'b0) S_next = 1'b1;
        else           // next state B0 (bit 4)
          B3_next = 1'b0; // We'll fix below for B0
      end
      B0: begin
        shift_ena = 1'b1;
        // next state B1 (bit 5)
      end
      B1: begin
        shift_ena = 1'b1;
        // next state B2 (bit 6)
      end
      B2: begin
        shift_ena = 1'b1;
        // next state B3 (bit 7)
      end
      B3: begin
        shift_ena = 1'b1;
        B3_next = 1'b1; // next state is Count (bit 8)
      end
      Count: begin
        counting = 1'b1;
        if (done_counting == 1'b0)
          Count_next = 1'b1;
        else
          Wait_next = 1'b1;
      end
      Wait: begin
        done = 1'b1;
        if (ack == 1'b1)
          S_next = 1'b1;
        else
          Wait_next = 1'b1;
      end
      default: begin
        // To avoid latch inference
      end
    endcase

    // Because casez cannot directly check individual one-hot bits in case, rewrite logic with explicit per-state branches:

    // To get correct one-hot next-state signals, implement with if-else ladder:

    // Reset all next signals
    B3_next    = 1'b0;
    S_next     = 1'b0;
    S1_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;
    done       = 1'b0;
    counting   = 1'b0;
    shift_ena  = 1'b0;

    // Determine current state by checking one-hot bits
    if (state == S) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        S1_next = 1'b1;
    end
    else if (state == S1) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        S1_next = 1'b1 << 1; // incorrect; fix by explicit assignment below
      // Correct:
      if (d == 1'b0)
        S_next = 1'b1;
      else
        S1_next = 1'b1 << 1; // S11 is bit 2
    end
    else if (state == S11) begin
      if (d == 1'b0)
        S_next = 1'b0;
      else
        S1_next = 1'b1 << 2; // stays at S11 (bit 2)
      if (d == 1'b0)
        // next is S110 (bit 3)
        S1_next = 1'b1 << 3;
      else
        S1_next = 1'b1 << 2;
    end
    else if (state == S110) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        // B0 is bit 4
        B3_next = 1'b0; // need explicit B0_next signal - missing in spec - add it
    end
    else if (state == B0) begin
      shift_ena = 1'b1;
      // next B1 bit 5
    end
    else if (state == B1) begin
      shift_ena = 1'b1;
      // next B2 bit 6
    end
    else if (state == B2) begin
      shift_ena = 1'b1;
      // next B3 bit 7
    end
    else if (state == B3) begin
      shift_ena = 1'b1;
      B3_next = 1'b1; // next is Count bit 8
    end
    else if (state == Count) begin
      counting = 1'b1;
      if (done_counting == 1'b0)
        Count_next = 1'b1;
      else
        Wait_next = 1'b1;
    end
    else if (state == Wait) begin
      done = 1'b1;
      if (ack == 1'b1)
        S_next = 1'b1;
      else
        Wait_next = 1'b1;
    end

    // Assign missing next states for B0, B1, B2, S110, S11, S1:

    // B0 next is B1
    if (state == B0) begin
      shift_ena = 1'b1;
      // next B1 (bit 5)
      B3_next    = 1'b0;
      S_next     = 1'b0;
      S1_next    = 1'b0;
      Count_next = 1'b0;
      Wait_next  = 1'b0;
      S1_next    = 1'b0;
      // Implement B1_next as B1_next signal (not requested), so set no next state except B3_next which is for B3 only
      // To meet spec, we have only next state outputs for B3_next, S_next, S1_next, Count_next, Wait_next
      // So no output signal for B1_next or B2_next is requested.
      // Since B1 and B2 are part of shift_ena only, no next state signals needed for B1_next or B2_next
    end

    // Similarly B1 next is B2; B2 next is B3; B3 next is Count (Count_next=1)

    if (state == B1) begin
      shift_ena = 1'b1;
    end

    if (state == B2) begin
      shift_ena = 1'b1;
    end

    if (state == B3) begin
      shift_ena = 1'b1;
      B3_next = 1'b1;
    end

    // S110 next states:
    if (state == S110) begin
      if (d == 1'b0)
        S_next = 1'b1;
      else
        // B0 next is not exposed; no output for B0_next, so no assertion for requested signals
        ;
    end

    // S11 next states:
    if (state == S11) begin
      if (d == 1'b0) begin
        // next is S110 (bit 3)
        // no output signal requested for S110_next, so none asserted
      end else begin
        // next stays in S11
      end
    end

    // S1 next states:
    if (state == S1) begin
      if (d == 0)
        S_next = 1'b1;
      else
        S1_next = 1'b1 << 2; // S11 bit 2
    end
  end

endmodule