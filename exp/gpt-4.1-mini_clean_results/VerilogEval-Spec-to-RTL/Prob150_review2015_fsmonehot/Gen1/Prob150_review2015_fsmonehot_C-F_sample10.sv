module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding of current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

    // State indices for clarity
    localparam S_bit    = 0;
    localparam S1_bit   = 1;
    localparam S11_bit  = 2;
    localparam S110_bit = 3;
    localparam B0_bit   = 4;
    localparam B1_bit   = 5;
    localparam B2_bit   = 6;
    localparam B3_bit   = 7;
    localparam Count_bit= 8;
    localparam Wait_bit = 9;

    // Current state decoded signals for readability
    wire S     = state[S_bit];
    wire S1    = state[S1_bit];
    wire S11   = state[S11_bit];
    wire S110  = state[S110_bit];
    wire B0    = state[B0_bit];
    wire B1    = state[B1_bit];
    wire B2    = state[B2_bit];
    wire B3    = state[B3_bit];
    wire Count = state[Count_bit];
    wire Wait  = state[Wait_bit];

    // ----------------------------------------------------------------------------
    // Next state partial signals per transition from current state and inputs
    // These represent "from current state + inputs -> next state" conditions
    // ----------------------------------------------------------------------------

    // From S (bit 0)
    wire S_next_from_S   = S    & ~d;
    wire S1_next_from_S  = S    &  d;

    // From S1 (bit 1)
    wire S_next_from_S1  = S1   & ~d;
    wire S11_next_from_S1= S1   &  d;

    // From S11 (bit 2)
    wire S110_next_from_S11 = S11 & ~d;
    wire S11_next_from_S11  = S11 &  d;

    // From S110 (bit 3)
    wire S_next_from_S110 = S110 & ~d;
    wire B0_next_from_S110= S110 &  d;

    // From B0 (bit 4): unconditional next to B1
    wire B1_next_from_B0 = B0;

    // From B1 (bit 5): unconditional next to B2
    wire B2_next_from_B1 = B1;

    // From B2 (bit 6): unconditional next to B3
    wire B3_next_from_B2 = B2;

    // From B3 (bit 7): unconditional next to Count
    wire Count_next_from_B3 = B3;

    // From Count (bit 8)
    wire Count_next_from_Count = Count & (~done_counting);
    wire Wait_next_from_Count  = Count & done_counting;

    // From Wait (bit 9)
    wire Wait_next_from_Wait = Wait & (~ack);
    wire S_next_from_Wait    = Wait & ack;

    // ----------------------------------------------------------------------------
    // Aggregate all conditions for each next state signal (one-hot)
    // ----------------------------------------------------------------------------

    assign S_next = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
    assign S1_next = S1_next_from_S;
    // S11_next is intermediate, no output port required - omit
    assign B3_next = B3_next_from_B2;
    assign Count_next = Count_next_from_B3 | Count_next_from_Count;
    assign Wait_next = Wait_next_from_Count | Wait_next_from_Wait;

    // ----------------------------------------------------------------------------
    // Output logic (Moore outputs depend only on current state)
    // ----------------------------------------------------------------------------

    // shift_ena = 1 in states B0, B1, B2, B3
    assign shift_ena = B0 | B1 | B2 | B3;

    // counting = 1 in state Count
    assign counting = Count;

    // done = 1 in state Wait
    assign done = Wait;

endmodule