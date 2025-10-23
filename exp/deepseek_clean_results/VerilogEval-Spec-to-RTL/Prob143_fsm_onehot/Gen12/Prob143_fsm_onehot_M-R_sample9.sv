module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains the same
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

// Precompute inverted input
wire in_n = ~in;

// Next state logic using continuous assignments
assign next_state[0] = (state[0] & in_n) |                     // S0 -> S0
                       (state[1] & in_n) |                     // S1 -> S0
                       (state[2] & in_n) |                     // S2 -> S0
                       (state[3] & in_n) |                     // S3 -> S0
                       (state[4] & in_n) |                     // S4 -> S0
                       (state[7] & in_n) |                      // S7 -> S0
                       (state[8] & in_n) |                      // S8 -> S0
                       (state[9] & in_n);                       // S9 -> S0

assign next_state[1] = (state[0] & in) |                        // S0 -> S1
                       (state[8] & in) |                        // S8 -> S1
                       (state[9] & in);                         // S9 -> S1

assign next_state[2] = state[1] & in;                           // S1 -> S2

assign next_state[3] = state[2] & in;                           // S2 -> S3

assign next_state[4] = state[3] & in;                           // S3 -> S4

assign next_state[5] = state[4] & in;                           // S4 -> S5

assign next_state[6] = state[5] & in;                           // S5 -> S6

assign next_state[7] = (state[6] & in) |                        // S6 -> S7
                       (state[7] & in);                         // S7 -> S7

assign next_state[8] = state[5] & in_n;                         // S5 -> S8

assign next_state[9] = state[6] & in_n;                         // S6 -> S9

endmodule