module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state A: active when (current A and in=0) OR (current C and in=0)
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);

    // Next state B: active when (current A and in=1) OR (current B and in=1) OR (current D and in=1)
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);

    // Next state C: active when (current B and in=0) OR (current D and in=0)
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);

    // Next state D: active when (current C and in=1)
    assign next_state[3] = in & state[2];

    // Output is high only in state D
    assign out = state[3];

endmodule