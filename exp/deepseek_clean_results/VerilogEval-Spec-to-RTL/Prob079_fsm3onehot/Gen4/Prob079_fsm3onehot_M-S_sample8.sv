module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic (Moore machine)
    assign out = state[3];

    // Next state logic - each bit computed independently
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A transitions
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in); // B transitions
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in); // C transitions
    assign next_state[3] = (state[2] & in); // D transitions

endmodule