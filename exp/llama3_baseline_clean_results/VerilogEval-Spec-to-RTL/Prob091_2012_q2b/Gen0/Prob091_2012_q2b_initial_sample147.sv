module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input signal
    output       Y1, // Input to state flip-flop y[1] (state B)
    output       Y3  // Input to state flip-flop y[3] (state D)
);

// Next-state logic for Y1 (state B)
// A (000001) with w=1 transitions to B
assign Y1 = (y[0] && w); // From A to B

// Next-state logic for Y3 (state D)
// B (000010) with w=0 transitions to D
// C (000100) with w=0 transitions to D
// E (010000) with w=0 transitions to D
// D (001000) with w=0 transitions to A, so it does not contribute to Y3
// F (100000) with w=0 transitions to D
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[5] && ~w);

endmodule