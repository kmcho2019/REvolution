module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    assign {next_state[3:0], out} = {
        in & state[2],                // D (next_state[3])
        ~in & (state[1] | state[3]),  // C (next_state[2])
        in & ~state[2],                // B (next_state[1])
        ~in & |state[0:2:2],          // A (next_state[0]) - state[0] or state[2]
        state[3]                       // out
    };

endmodule