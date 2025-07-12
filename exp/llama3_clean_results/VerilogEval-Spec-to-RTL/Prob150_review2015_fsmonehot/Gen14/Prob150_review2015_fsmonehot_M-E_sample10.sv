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

    // Next-state logic using a two-stage approach
    wire [9:0] next_state;
    assign next_state[0] = (~d && (S || S1 || S110)) || (ack && Wait);  // S
    assign next_state[1] = d && S;  // S1
    assign next_state[2] = d && S11;  // S11
    assign next_state[3] = d && S110;  // S110
    assign next_state[4] = d && S110;  // B0
    assign next_state[5] = B0;  // B1
    assign next_state[6] = B1;  // B2
    assign next_state[7] = B2;  // B3
    assign next_state[8] = B3 || (~done_counting && Count);  // Count
    assign next_state[9] = done_counting && Count || (~ack && Wait);  // Wait

    // Output logic
    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule