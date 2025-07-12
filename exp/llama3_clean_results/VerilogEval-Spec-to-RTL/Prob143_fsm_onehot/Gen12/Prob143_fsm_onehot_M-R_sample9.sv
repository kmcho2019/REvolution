module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = {
        // S9
        (state[9] && !in) ? 1'b1 : 0,
        (state[9] && in) ? 1'b1 : 0,
        // S8
        (state[8] && !in) ? 1'b1 : 0,
        // S7
        (state[7] && !in) ? 1'b1 : 0,
        (state[7] && in) ? 1'b1 : 0,
        // S6
        (state[6] && !in) ? 1'b1 : 0,
        // S5
        (state[5] && !in) ? 1'b1 : 0,
        // S4
        (state[4] && !in) ? 1'b1 : 0,
        // S3
        (state[3] && !in) ? 1'b1 : 0,
        // S2
        (state[2] && !in) ? 1'b1 : 0,
        // S1
        (state[1] && !in) ? 1'b1 : 0,
        // S0
        ((state[0] || state[1] || state[2] || state[3] || state[4] || state[5] || state[7] || state[8] || state[9]) && !in) ? 1'b1 : 0
    };

    // Output logic
    assign out1 = (state[8] || state[9]);
    assign out2 = state[7];

endmodule