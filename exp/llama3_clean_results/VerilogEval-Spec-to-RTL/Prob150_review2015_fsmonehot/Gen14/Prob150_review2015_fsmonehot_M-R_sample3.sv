module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
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

    // Next-state logic equations
    wire S_to_S = ~d && S;
    wire S_to_S1 = d && S;
    wire S1_to_S = ~d && S1;
    wire S1_to_S11 = d && S1;
    wire S11_to_S110 = ~d && S11;
    wire S11_to_S11 = d && S11;
    wire S110_to_S = ~d && S110;
    wire S110_to_B0 = d && S110;
    wire B0_to_B1 = B0;
    wire B1_to_B2 = B1;
    wire B2_to_B3 = B2;
    wire B3_to_Count = B3;
    wire Count_to_Count = ~done_counting && Count;
    wire Count_to_Wait = done_counting && Count;
    wire Wait_to_Wait = ~ack && Wait;
    wire Wait_to_S = ack && Wait;

    assign B3_next = B2;
    assign S_next = S_to_S || S1_to_S || S110_to_S || Wait_to_S;
    assign S1_next = S_to_S1;
    assign Count_next = B3_to_Count || Count_to_Count;
    assign Wait_next = Count_to_Wait || Wait_to_Wait;

    // Output logic equations
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule