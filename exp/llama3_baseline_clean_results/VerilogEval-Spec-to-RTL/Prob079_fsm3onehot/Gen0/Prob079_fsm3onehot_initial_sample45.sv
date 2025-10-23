module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Derive next state logic based on current state and input
    assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[2]); // A
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]) | (~in & state[1]); // B
    assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C
    assign next_state[3] = (in & state[2]); // D

    // Derive output logic based on current state
    assign out = state[3]; // Output is 1 only when in state D

endmodule