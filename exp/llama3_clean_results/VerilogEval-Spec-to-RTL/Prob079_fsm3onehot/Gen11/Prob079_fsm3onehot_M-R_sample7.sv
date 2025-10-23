module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // Directly checking the bit corresponding to state D

    // State transition logic
    assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[0]); // A
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // B
    assign next_state[2] = (~in & state[1]); // C
    assign next_state[3] = (in & state[2]); // D

endmodule