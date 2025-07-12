module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // A (000) to B (001) when w = 0
    // B (001) to C (010) or D (011) when w = 0
    // C (010) to E (100) or D (011) when w = 0
    // D (011) to F (101) or A (000) when w = 0
    // E (100) to D (011) when w = 1
    // F (101) to C (010) or D (011) when w = 1

    // For y[1] to be 1 in the next state, the current state must be A or B with w = 0, 
    // or the current state must be C with w = 1, or the current state must be D or F with w = 1
    assign Y1 = ((~y[2] & ~y[1] & ~y[0] & ~w) | 
                (~y[2] & y[1] & ~y[0] & ~w) | 
                (~y[2] & ~y[1] & y[0] & w) | 
                (~y[2] & y[1] & y[0] & w) | 
                (y[2] & ~y[1] & ~y[0] & w) | 
                (y[2] & y[1] & ~y[0] & w));

endmodule