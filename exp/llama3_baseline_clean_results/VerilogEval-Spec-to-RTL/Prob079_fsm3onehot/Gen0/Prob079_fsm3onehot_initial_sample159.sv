module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A next state
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in) | (state[3] & ~in); // B next state
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in) | (state[2] & in); // C next state
    assign next_state[3] = (state[2] & in); // D next state

    assign out = state[3]; // Output based on current state D

endmodule