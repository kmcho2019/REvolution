module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Next state logic
    assign S_next = (~d & state[0]) | (~d & state[1]) | (~d & state[3]) | (ack & state[9]);
    assign S1_next = (d & state[0]) | (d & state[1]);
    assign B3_next = state[6];
    assign Count_next = state[7] | (~done_counting & state[8]);
    assign Wait_next = done_counting & state[8];

    // Output logic
    assign shift_ena = |state[4:7];  // B0-B3 states
    assign counting = state[8];     // Count state
    assign done = state[9];         // Wait state

endmodule