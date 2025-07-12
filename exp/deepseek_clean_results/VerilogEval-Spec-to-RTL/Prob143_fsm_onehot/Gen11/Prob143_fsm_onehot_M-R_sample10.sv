module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Common signals
wire in_n = ~in;

// Output logic remains the same
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Next state logic - each bit assigned separately
assign next_state[0] = (state[0] & in_n) |                // S0 stays on 0
                       (|state[4:1] & in_n) |            // S1-S4 go to S0 on 0
                       (state[7] & in_n) |                // S7 goes to S0 on 0
                       (|state[9:8] & in_n) |             // S8-S9 go to S0 on 0
                       (state[5] & in_n) |                // S5 goes to S0 via S8
                       (state[6] & in_n);                // S6 goes to S0 via S9

assign next_state[1] = (state[0] & in) |                  // S0->S1 on 1
                       (|state[9:8] & in);                // S8/S9->S1 on 1

assign next_state[2] = state[1] & in;                     // S1->S2 on 1
assign next_state[3] = state[2] & in;                     // S2->S3 on 1
assign next_state[4] = state[3] & in;                     // S3->S4 on 1
assign next_state[5] = state[4] & in;                     // S4->S5 on 1

assign next_state[6] = state[5] & in;                     // S5->S6 on 1
assign next_state[7] = (state[6] & in) |                  // S6->S7 on 1
                       (state[7] & in);                    // S7 stays on 1

assign next_state[8] = state[5] & in_n;                   // S5->S8 on 0
assign next_state[9] = state[6] & in_n;                   // S6->S9 on 0

endmodule