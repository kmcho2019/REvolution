module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    assign next_state = 10'b0;

    // Apply transition rules
    // If state S0 is active, transition to S0 if input is 0, and to S1 if input is 1
    assign next_state[0] = (state[0] && !in) || (state[1] && !in) || (state[2] && !in) || (state[3] && !in) || (state[4] && !in) || (state[5] && !in && !in) || (state[6] && !in && !in) || (state[7] && !in) || (state[8] && !in) || (state[9] && !in);
    assign next_state[1] = (state[0] && in) || (state[8] && in);
    assign next_state[2] = (state[1] && in);
    assign next_state[3] = (state[2] && in);
    assign next_state[4] = (state[3] && in);
    assign next_state[5] = (state[4] && in);
    assign next_state[6] = (state[5] && in);
    assign next_state[7] = (state[6] && in);
    assign next_state[8] = (state[5] && !in);
    assign next_state[9] = (state[6] && !in);

    // Apply output rules
    // out1 is 1 if state S7 or S9 is active
    assign out1 = state[7] || state[9] || state[8];

    // out2 is 1 if state S7 is active
    assign out2 = state[7] || state[9];

endmodule