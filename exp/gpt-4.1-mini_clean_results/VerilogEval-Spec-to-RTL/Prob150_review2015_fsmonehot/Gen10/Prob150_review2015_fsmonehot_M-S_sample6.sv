module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

    // One-hot state bits for clarity
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

    // Next state logic directly for requested signals only
    // S_next: from S when d=0, from S1 when d=0, from S110 when d=0, from Wait when ack=1
    assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

    // S1_next: from S when d=1
    assign S1_next = S & d;

    // B3_next: from B2 (automatic progression)
    assign B3_next = B2;

    // Count_next: from B3, and from Count when done_counting=0
    assign Count_next = B3 | (Count & ~done_counting);

    // Wait_next: from Count when done_counting=1, from Wait when ack=0
    assign Wait_next = (Count & done_counting) | (Wait & ~ack);

    // Moore outputs depend only on current state
    assign done      = Wait;
    assign counting  = Count;
    assign shift_ena = B0 | B1 | B2 | B3;

endmodule