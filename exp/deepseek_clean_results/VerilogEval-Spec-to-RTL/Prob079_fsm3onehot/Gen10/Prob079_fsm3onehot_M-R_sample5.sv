module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Consolidated state transition logic using concatenation
    assign next_state = {
        in & state[2],                // next_state[3]: D (from C when in=1)
        ~in & (state[1] | state[3]),   // next_state[2]: C (from B or D when in=0)
        in & ~state[2],                // next_state[1]: B (from A,B,D when in=1)
        ~in & (state[0] | state[2])    // next_state[0]: A (from A or C when in=0)
    };

    // Output remains simple direct assignment
    assign out = state[3];

endmodule