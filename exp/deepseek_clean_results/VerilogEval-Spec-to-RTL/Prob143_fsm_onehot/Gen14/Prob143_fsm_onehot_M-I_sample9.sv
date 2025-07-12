module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Precompute all common signals
wire in_n = ~in;
wire any_S1_S4 = |state[4:1];
wire any_S8_S9 = |state[9:8];
wire S5_or_S6 = |state[6:5];

always @(*) begin
    // Default assignments
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;
    
    // Output logic (now registered to reduce glitching)
    out1 = state[8] | state[9];
    out2 = state[7] | state[9];
    
    // State transition logic using parallel evaluation
    next_state[0] = (state[0] & in_n) |                 // S0->S0
                    (any_S1_S4 & in_n) |                // S1-S4->S0
                    (state[5] & in_n) |                 // S5->S0 via S8
                    (state[6] & in_n) |                // S6->S0 via S9
                    (state[7] & in_n) |                 // S7->S0
                    (any_S8_S9 & in_n);                 // S8-S9->S0
    
    next_state[1] = (state[0] & in) |                  // S0->S1
                    (any_S8_S9 & in);                  // S8-S9->S1
    
    next_state[2] = state[1] & in;                     // S1->S2
    next_state[3] = state[2] & in;                     // S2->S3
    next_state[4] = state[3] & in;                     // S3->S4
    next_state[5] = state[4] & in;                     // S4->S5
    
    next_state[6] = state[5] & in;                     // S5->S6
    next_state[7] = (state[6] & in) |                  // S6->S7
                    (state[7] & in);                   // S7->S7
    
    next_state[8] = state[5] & in_n;                   // S5->S8
    next_state[9] = state[6] & in_n;                   // S6->S9
end

endmodule