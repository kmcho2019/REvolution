module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to zero
assign next_state = 10'b0;

// S0
assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[8] | state[9])) | 
                        (in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[8] | state[9])) | 
                        (~in & state[5] & ~in & state[6]) | 
                        (~in & state[5] & in & state[7]);

// S1
assign next_state[1] = in & (state[0] | state[1] | state[8] | state[9]);

// S2
assign next_state[2] = in & state[1];

// S3
assign next_state[3] = in & state[2];

// S4
assign next_state[4] = in & state[3];

// S5
assign next_state[5] = in & state[4];

// S6
assign next_state[6] = in & state[5];

// S7
assign next_state[7] = in & state[6];

// S8
assign next_state[8] = (~in & state[5]);

// S9
assign next_state[9] = (~in & state[6]);

// Outputs
assign out1 = state[7] | state[8] | state[9];
assign out2 = state[7] | state[9];

endmodule