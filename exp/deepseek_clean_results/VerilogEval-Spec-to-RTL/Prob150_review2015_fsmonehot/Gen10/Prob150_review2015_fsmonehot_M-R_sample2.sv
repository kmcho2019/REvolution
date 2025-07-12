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

    // Intermediate signals for readability
    wire from_S = state[0];
    wire from_S1 = state[1];
    wire from_S11 = state[2];
    wire from_S110 = state[3];
    wire from_B0 = state[4];
    wire from_B1 = state[5];
    wire from_B2 = state[6];
    wire from_B3 = state[7];
    wire from_Count = state[8];
    wire from_Wait = state[9];

    // Next state logic - broken down for clarity
    wire to_S_from_S = from_S & ~d;
    wire to_S_from_S1 = from_S1 & ~d;
    wire to_S_from_S110 = from_S110 & ~d;
    wire to_S_from_Wait = from_Wait & ack;
    
    assign S_next = to_S_from_S | to_S_from_S1 | to_S_from_S110 | to_S_from_Wait;
    assign S1_next = from_S & d;
    
    // B-state progression is a simple shift
    assign B3_next = from_B2;
    
    // Counting state transitions
    wire stay_in_Count = from_Count & ~done_counting;
    wire to_Count_from_B3 = from_B3;
    assign Count_next = to_Count_from_B3 | stay_in_Count;
    
    // Wait state transitions
    wire to_Wait_from_Count = from_Count & done_counting;
    wire stay_in_Wait = from_Wait & ~ack;
    assign Wait_next = to_Wait_from_Count | stay_in_Wait;

    // Output logic - direct and clear
    assign done = from_Wait;
    assign counting = from_Count;
    assign shift_ena = (state[4:7] != 4'b0);  // Any B-state (B0-B3)

endmodule