module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// State groups
wire group0_5 = |state[0:5];  // S0-S5
wire group6_7 = |state[6:7];  // S6-S7
wire group8_9 = |state[8:9];  // S8-S9

// Output logic (only active for S7-S9)
assign out1 = group8_9;
assign out2 = (state[7] | state[9]);

// Transition logic for each state group
wire [9:0] next_group0_5 = {
    (state[5] & ~in),    // S5->S8 (encoded as bit 8)
    1'b0,                 // Unused
    (state[4] & in),     // S4->S5
    (state[3] & in),     // S3->S4
    (state[2] & in),     // S2->S3
    (state[1] & in),     // S1->S2
    (state[0] & in),     // S0->S1
    1'b0,                // Unused
    1'b0,                // Unused
    (~in & (|state[0:5])) // Default to S0 for any state in group0_5 when in=0
};

wire [9:0] next_group6_7 = {
    (state[7] & ~in),    // S7->S0
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    (state[6] & in),     // S6->S7
    (state[7] & in),     // S7->S7 (self-loop)
    (state[6] & ~in),    // S6->S9 (encoded as bit 9)
    1'b0                 // Unused
};

wire [9:0] next_group8_9 = {
    (~in),               // S8/S9->S0
    (in),                // S8/S9->S1
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0,                // Unused
    1'b0                 // Unused
};

// Priority-based next state selection
assign next_state = (group8_9 ? next_group8_9 : 
                    (group6_7 ? next_group6_7 : 
                    (group0_5 ? next_group0_5 : 10'b0))) | 
                    {10{~in & (|state)}};  // Ensure S0 transition when in=0

endmodule