module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Assign next state values for each state
    wire next_state_S0 = ~in ? 1'b1 : 1'b0;
    wire next_state_S1 = ~in ? 1'b1 : 1'b0;
    wire next_state_S2 = ~in ? 1'b1 : 1'b0;
    wire next_state_S3 = ~in ? 1'b1 : 1'b0;
    wire next_state_S4 = ~in ? 1'b1 : 1'b0;
    wire next_state_S5 = ~in ? 1'b1 : 1'b0;
    wire next_state_S6 = ~in ? 1'b1 : 1'b0;
    wire next_state_S7 = ~in ? 1'b1 : 1'b0;
    wire next_state_S8 = ~in ? 1'b1 : 1'b0;
    wire next_state_S9 = ~in ? 1'b1 : 1'b0;

    assign next_state[0] = (state[0] && ~in) || (state[1] && ~in) || (state[2] && ~in) || (state[3] && ~in) || (state[4] && ~in) || (state[5] && ~in) || (state[6] && ~in) || (state[7] && ~in) || (state[8] && ~in) || (state[9] && ~in);
    assign next_state[1] = (state[0] && in) || (state[8] && in) || (state[9] && in);
    assign next_state[2] = (state[1] && in);
    assign next_state[3] = (state[2] && in);
    assign next_state[4] = (state[3] && in);
    assign next_state[5] = (state[4] && in);
    assign next_state[6] = (state[5] && in);
    assign next_state[7] = (state[6] && in) || (state[7] && in);
    assign next_state[8] = (state[5] && ~in);
    assign next_state[9] = (state[6] && ~in);

    // Assign output values
    assign out1 = state[8] || state[9] || (state[7] && in);
    assign out2 = state[7] && in || (state[9] && in);

endmodule