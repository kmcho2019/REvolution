module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // Next state A occurs when:
    // - Current state A and in=0
    // - Current state C and in=0
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);

    // Next state B occurs when:
    // - Current state A and in=1
    // - Current state B and in=1
    // - Current state D and in=1
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);

    // Next state C occurs when:
    // - Current state B and in=0
    // - Current state D and in=0
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);

    // Next state D occurs when:
    // - Current state C and in=1
    assign next_state[3] = (in & state[2]);

    // Output is 1 only in state D
    assign out = state[3];

endmodule