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

    // Common subexpressions
    wire from_S = state[0];
    wire from_S1 = state[1];
    wire from_S110 = state[3];
    wire from_Count = state[8];
    wire from_Wait = state[9];

    // Next state logic with balanced paths
    assign S_next = (from_S & ~d) | 
                   (from_S1 & ~d) | 
                   (from_S110 & ~d) | 
                   (from_Wait & ack);
    
    assign S1_next = from_S & d;
    assign B3_next = state[6];
    assign Count_next = state[7] | (from_Count & ~done_counting);
    assign Wait_next = (from_Count & done_counting) | (from_Wait & ~ack);

    // Output logic with minimized switching
    assign done = from_Wait;
    assign counting = from_Count;
    assign shift_ena = |state[7:4];  // More efficient OR reduction for B0-B3 states

endmodule