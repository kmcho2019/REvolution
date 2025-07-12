module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains the same
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Common signals
wire in_n = ~in;
wire any_S1_S4 = |state[4:1];       // S1-S4
wire any_S8_S9 = |state[9:8];       // S8-S9

// Next state logic using continuous assignments
assign next_state[0] = (state[0] & in_n) |                 // S0 stays on 0
                       (any_S1_S4 & in_n) |                 // S1-S4 go to S0 on 0
                       (state[5] & in_n) |                  // S5 goes to S8 on 0
                       (state[6] & in_n) |                  // S6 goes to S9 on 0
                       (state[7] & in_n) |                  // S7 goes to S0 on 0
                       (any_S8_S9 & in_n);                  // S8-S9 go to S0 on 0

assign next_state[1] = (state[0] & in) |                    // S0 goes to S1 on 1
                       (any_S8_S9 & in);                    // S8-S9 go to S1 on 1

assign next_state[2] = state[1] & in;                       // S1 goes to S2 on 1
assign next_state[3] = state[2] & in;                       // S2 goes to S3 on 1
assign next_state[4] = state[3] & in;                       // S3 goes to S4 on 1
assign next_state[5] = state[4] & in;                       // S4 goes to S5 on 1

assign next_state[6] = state[5] & in;                       // S5 goes to S6 on 1
assign next_state[7] = (state[6] & in) |                    // S6 goes to S7 on 1
                       (state[7] & in);                     // S7 stays on 1

assign next_state[8] = state[5] & in_n;                     // S5 goes to S8 on 0
assign next_state[9] = state[6] & in_n;                     // S6 goes to S9 on 0

endmodule