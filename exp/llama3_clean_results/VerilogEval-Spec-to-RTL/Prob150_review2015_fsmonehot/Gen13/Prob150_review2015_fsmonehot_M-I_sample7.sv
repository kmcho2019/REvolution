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

    // Optimized next-state logic equations
    assign B3_next = B2;  // Direct transition
    assign S_next = (~d && (S || S1 || S110)) || (ack && Wait);  // Simplified condition
    assign S1_next = d && S;  // Direct transition
    assign Count_next = (B3 || (~done_counting && Count));  // Reduced redundancy
    assign Wait_next = (done_counting && Count) || (~ack && Wait);  // Simplified condition

    // Optimized output logic equations
    assign done = Wait;  // Direct assignment
    assign counting = Count;  // Direct assignment
    assign shift_ena = (B0 || B1 || B2 || B3);  // Simplified condition

endmodule