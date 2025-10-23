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

    // Intermediate wires for next-state logic
    wire stay_in_S     = S && ~d;
    wire go_to_S1      = S && d;
    wire go_to_S110    = S11 && ~d;
    wire go_to_Count   = B3;
    wire stay_in_Count = Count && ~done_counting;
    wire go_to_Wait    = Count && done_counting;
    wire stay_in_Wait  = Wait && ~ack;

    // Next-state logic equations
    assign B3_next = B2; // B2 always goes to B3
    assign S_next  = stay_in_S || go_to_S110 || stay_in_Wait;
    assign S1_next = go_to_S1;
    assign Count_next = go_to_Count || stay_in_Count;
    assign Wait_next = go_to_Wait || stay_in_Wait;

    // Output logic equations
    assign done     = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule