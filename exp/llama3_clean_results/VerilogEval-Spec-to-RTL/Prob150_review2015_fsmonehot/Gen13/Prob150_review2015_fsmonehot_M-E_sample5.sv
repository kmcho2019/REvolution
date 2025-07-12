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

    // Data Processing Sub-Module
    wire go_to_B0;
    assign go_to_B0 = (S110 && d);
    assign S_next = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next = (S && d);
    assign go_to_S11 = (S1 && d);
    assign go_to_S110 = (S11 && d);

    // Counting and Waiting Sub-Module
    wire go_to_B1, go_to_B2, go_to_B3, go_to_Count;
    assign go_to_B1 = (B0);
    assign go_to_B2 = (B1);
    assign go_to_B3 = (B2);
    assign go_to_Count = (B3);
    assign B3_next = go_to_B3;
    assign Count_next = go_to_Count || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

    // Output Logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule