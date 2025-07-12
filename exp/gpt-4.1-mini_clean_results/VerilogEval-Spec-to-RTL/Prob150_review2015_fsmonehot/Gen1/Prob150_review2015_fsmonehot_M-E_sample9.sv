module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // One-hot encoding: bit0=S, bit1=S1, ..., bit9=Wait
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // Define state bit indices for readability
    localparam S_BIT    = 0;
    localparam S1_BIT   = 1;
    localparam S11_BIT  = 2;
    localparam S110_BIT = 3;
    localparam B0_BIT   = 4;
    localparam B1_BIT   = 5;
    localparam B2_BIT   = 6;
    localparam B3_BIT   = 7;
    localparam COUNT_BIT= 8;
    localparam WAIT_BIT = 9;

    // Extract current states
    wire S     = state[S_BIT];
    wire S1    = state[S1_BIT];
    wire S11   = state[S11_BIT];
    wire S110  = state[S110_BIT];
    wire B0    = state[B0_BIT];
    wire B1    = state[B1_BIT];
    wire B2    = state[B2_BIT];
    wire B3    = state[B3_BIT];
    wire Count = state[COUNT_BIT];
    wire Wait  = state[WAIT_BIT];

    // Next state logic for requested outputs:

    // S_next can come from:
    //  S(d=0), S1(d=0), S110(d=0), or Wait(ack=1)
    assign S_next = (S & ~d)
                  | (S1 & ~d)
                  | (S110 & ~d)
                  | (Wait & ack);

    // S1_next comes only from S(d=1)
    assign S1_next = S & d;

    // B3_next comes from B2 (always move forward)
    assign B3_next = B2;

    // Count_next comes from B3 always, or stays in Count if done_counting=0
    assign Count_next = B3 | (Count & ~done_counting);

    // Wait_next comes from Count(done_counting=1) or stays in Wait if ack=0
    assign Wait_next = (Count & done_counting) | (Wait & ~ack);

    // done is high in Wait state
    assign done = Wait;

    // counting is high in Count state
    assign counting = Count;

    // shift_ena asserted during B0,B1,B2,B3 states
    assign shift_ena = B0 | B1 | B2 | B3;

endmodule