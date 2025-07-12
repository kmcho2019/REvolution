module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Maintaining original interface
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // State decoding (from original one-hot)
    wire in_S = state[0];
    wire in_S1 = state[1];
    wire in_S11 = state[2];
    wire in_S110 = state[3];
    wire in_B0 = state[4];
    wire in_B1 = state[5];
    wire in_B2 = state[6];
    wire in_B3 = state[7];
    wire in_Count = state[8];
    wire in_Wait = state[9];

    // Next state logic with hierarchical optimization
    assign S_next = (in_S & ~d) | (in_S1 & ~d) | (in_S110 & ~d) | (in_Wait & ack);
    assign S1_next = in_S & d;
    
    // Bit shifting states progression
    wire shifting_states = in_B0 | in_B1 | in_B2 | in_B3;
    assign B3_next = in_B2;
    
    // Counting/Waiting states transitions
    assign Count_next = in_B3 | (in_Count & ~done_counting);
    assign Wait_next = (in_Count & done_counting) | (in_Wait & ~ack);

    // Output logic with hierarchical optimization
    assign done = in_Wait;
    assign counting = in_Count;
    
    // Shift enable is active in all bit shifting states
    assign shift_ena = shifting_states;

endmodule