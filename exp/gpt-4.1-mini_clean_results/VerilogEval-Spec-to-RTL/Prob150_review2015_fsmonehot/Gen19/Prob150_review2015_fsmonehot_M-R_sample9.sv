module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding of current state
    output reg         B3_next,
    output reg         S_next,
    output reg         S1_next,
    output reg         Count_next,
    output reg         Wait_next,
    output reg         done,
    output reg         counting,
    output reg         shift_ena
);

  // State bit indices for readability
  localparam S_bit     = 0;
  localparam S1_bit    = 1;
  localparam S11_bit   = 2;
  localparam S110_bit  = 3;
  localparam B0_bit    = 4;
  localparam B1_bit    = 5;
  localparam B2_bit    = 6;
  localparam B3_bit    = 7;
  localparam Count_bit = 8;
  localparam Wait_bit  = 9;

  always @(*) begin
    // Default outputs
    B3_next     = 1'b0;
    S_next      = 1'b0;
    S1_next     = 1'b0;
    Count_next  = 1'b0;
    Wait_next   = 1'b0;
    done        = 1'b0;
    counting    = 1'b0;
    shift_ena   = 1'b0;

    casez(state)
      10'b???????1??: begin // Wait state (bit 9)
        done = 1'b1;
        if (ack)
          S_next = 1'b1;
        else
          Wait_next = 1'b1;
      end
      10'b??????1???: begin // Count state (bit 8)
        counting = 1'b1;
        if (done_counting)
          Wait_next = 1'b1;
        else
          Count_next = 1'b1;
      end
      10'b?????1????: begin // B3 state (bit 7)
        shift_ena = 1'b1;
        Count_next = 1'b1;
      end
      10'b????1?????: begin // B2 state (bit 6)
        shift_ena = 1'b1;
        B3_next = 1'b1;
      end
      10'b???1??????: begin // B1 state (bit 5)
        shift_ena = 1'b1;
        B2_next = 1'b1; // B2_next not required as output, so assign in code below instead
      end
      10'b??1???????: begin // B0 state (bit 4)
        shift_ena = 1'b1;
        // B1_next signal not required as output, but needed internally:
        // We will treat B1_next logic after this case to assign B1_next.
      end
      10'b?1????????: begin // S110 state (bit 3)
        if (d)
          B0_next = 1'b1;
        else
          S_next = 1'b1;
      end
      10'b1?????????: begin // S11 state (bit 2)
        if (d)
          S11_next = 1'b1; // S11_next not output, so assign nothing here
        else
          S110_next = 1'b1; // Also not output, assign nothing here
      end
      10'b0?????????: begin // S1 state (bit 1)
        if (d)
          S11_next = 1'b1; // Not output, no assignment
        else
          S_next = 1'b1;
      end
      10'b????????01: begin // S state (bit 0)
        if (d)
          S1_next = 1'b1;
        else
          S_next = 1'b1;
      end
      default: begin
        // No valid current state active, keep outputs zero
      end
    endcase

    // Since B1_next and B2_next, etc. are not outputs, we will derive B1_next and B2_next logic here and
    // assign their influence to known next state outputs as needed.

    // Implement implicit next-state logic that leads to the known output next states:

    // For B0 state (bit 4), next is always B1:
    if (state[B0_bit]) begin
      shift_ena = 1'b1;
      // B1_next is not an output, but it eventually leads to B2_next, then B3_next
      // So next states are B1 -> B2 -> B3 chain
      // We can model B1 and B2 internally via signals that lead to B3_next = 1 when state is B2
      // For next-state outputs requested, only B3_next signal is required; others are unused.
    end

    // For B1 state (bit 5), next state is B2:
    // No output next-state signals requested for B1_next, B2_next,
    // so no assignments needed except shift_ena already assigned.

    // For S11 state (bit 2) and S110 state (bit 3), no output next states required except S_next and B0_next.
    // For next states that are not output signals, no assignment needed.

  end

  // To cover missing next-state output assignments for B3_next, S_next, S1_next, Count_next, Wait_next for
  // states that have no direct next-state outputs in casez (like B1 and B2),
  // we implement combinational assignments here with assign statements for clarity.

  // Assign B3_next when current state is B2 (bit 6)
  wire state_B2 = state[B2_bit];
  wire state_B1 = state[B1_bit];
  wire state_B0 = state[B0_bit];

  always @(*) begin
    // override B3_next for B2 state
    if(state_B2)
      B3_next = 1'b1;
    // override Count_next for B3 state
    if(state[B3_bit])
      Count_next = 1'b1;
    // override B1_next for B0 state is not output, so no signal
    // override B2_next for B1 state is not output, so no signal
  end

endmodule