module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    wire in_not = ~in;

    // Intermediate common terms for logic sharing
    wire AorC     = state[0] | state[2];
    wire BorD     = state[1] | state[3];
    wire AorBorD  = state[0] | state[1] | state[3];

    // Next state logic (combinational)
    assign next_state[0] = in_not & AorC;        // Next state A: in=0 and state A or C
    assign next_state[1] = in     & AorBorD;     // Next state B: in=1 and state A or B or D
    assign next_state[2] = in_not & BorD;        // Next state C: in=0 and state B or D
    assign next_state[3] = in     & state[2];    // Next state D: in=1 and state C

    // Output logic (Moore output depends on state D)
    assign out = state[3];

endmodule