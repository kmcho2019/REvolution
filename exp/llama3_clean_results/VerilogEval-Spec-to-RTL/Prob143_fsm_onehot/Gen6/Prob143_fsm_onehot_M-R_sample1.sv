module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Directly calculate next state and outputs based on one-hot encoding
    assign next_state[0] = (!in) && (state[0] || state[1] || state[2] || state[3] || state[4] || state[7] || state[8] || state[9]);
    assign next_state[1] = (in) && (state[0] || state[8] || state[9]);
    assign next_state[2] = (in) && state[1];
    assign next_state[3] = (in) && state[2];
    assign next_state[4] = (in) && state[3];
    assign next_state[5] = (in) && state[4];
    assign next_state[6] = (in) && state[5];
    assign next_state[7] = (in) && state[6] || (in) && state[7];
    assign next_state[8] = (!in) && state[5];
    assign next_state[9] = (!in) && state[6];

    assign out1 = (state[8] || state[9]);
    assign out2 = state[7] || state[9];

    // Ensure that next_state is zero for all other states not explicitly assigned
    assign next_state[10] = 1'b0; // Since next_state is [9:0], this line is redundant but added for clarity
    // In actual implementation, this line would be unnecessary as next_state is already defined as [9:0]

endmodule