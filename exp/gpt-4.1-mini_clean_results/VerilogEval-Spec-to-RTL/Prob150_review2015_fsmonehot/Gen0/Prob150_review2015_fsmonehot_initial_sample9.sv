module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoded states: S=0000000001 (bit0), S1=0000000010 (bit1), ..., Wait=1000000000 (bit9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State bit indices for clarity
    localparam S    = 0;
    localparam S1   = 1;
    localparam S11  = 2;
    localparam S110 = 3;
    localparam B0   = 4;
    localparam B1   = 5;
    localparam B2   = 6;
    localparam B3   = 7;
    localparam Count= 8;
    localparam Wait = 9;

    // next-state logic signals - one-hot encoded for next state
    // Each signal is 1 when next state is that state

    // Next-state from S (bit0)
    wire S_next_from_S  = state[S]   & (d == 1'b0);
    wire S1_next_from_S = state[S]   & (d == 1'b1);

    // Next-state from S1 (bit1)
    wire S_next_from_S1  = state[S1] & (d == 1'b0);
    wire S11_next_from_S1= state[S1] & (d == 1'b1);

    // Next-state from S11 (bit2)
    wire S110_next_from_S11 = state[S11] & (d == 1'b0);
    wire S11_next_from_S11  = state[S11] & (d == 1'b1);

    // Next-state from S110 (bit3)
    wire S_next_from_S110 = state[S110] & (d == 1'b0);
    wire B0_next_from_S110= state[S110] & (d == 1'b1);

    // Next-state from B0 (bit4)
    wire B1_next_from_B0 = state[B0]; // always go next cycle

    // Next-state from B1 (bit5)
    wire B2_next_from_B1 = state[B1]; // always go next cycle

    // Next-state from B2 (bit6)
    wire B3_next_from_B2 = state[B2]; // always go next cycle

    // Next-state from B3 (bit7)
    wire Count_next_from_B3 = state[B3]; // always go next cycle

    // Next-state from Count (bit8)
    wire Count_next_from_Count = state[Count] & (~done_counting);
    wire Wait_next_from_Count  = state[Count] & done_counting;

    // Next-state from Wait (bit9)
    wire Wait_next_from_Wait = state[Wait] & (~ack);
    wire S_next_from_Wait    = state[Wait] & ack;

    // Combine all next-state signals for each state

    assign S_next = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
    assign S1_next = S1_next_from_S;
    assign B3_next = B3_next_from_B2;
    assign Count_next = Count_next_from_B3 | Count_next_from_Count;
    assign Wait_next = Wait_next_from_Count | Wait_next_from_Wait;

    // S11_next: not required as output, but used internally - not output port.

    // Output logic (Moore)

    // shift_ena=1 in states B0, B1, B2, B3
    assign shift_ena = state[B0] | state[B1] | state[B2] | state[B3];

    // counting=1 in state Count
    assign counting = state[Count];

    // done=1 in state Wait
    assign done = state[Wait];

endmodule