module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Shared terms
    wire state0_in = state[0] & in;
    wire state1_in = state[1] & in;
    wire state3_in = state[3] & in;
    wire state0_nin = state[0] & ~in;
    wire state1_nin = state[1] & ~in;
    wire state2_nin = state[2] & ~in;
    wire state3_nin = state[3] & ~in;
    wire state2_in = state[2] & in;

    // Optimized next state logic
    assign next_state[0] = state0_nin | state2_nin;
    assign next_state[1] = state0_in | state1_in | state3_in;
    assign next_state[2] = state1_nin | state3_nin;
    assign next_state[3] = state2_in;

    // Output logic
    assign out = state[3];

endmodule