module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);
    // State encoding:
    // y[0] = A
    // y[1] = B
    // y[2] = C
    // y[3] = D
    // y[4] = E
    // y[5] = F

    // Next state for B (y[1]) from transitions:
    // A (y[0]) --0--> B => if y[0] & ~w
    // No other transitions lead to B directly
    // So Y1 = y[0] & ~w

    // Next state for D (y[3]) from transitions:
    // B (y[1]) --1--> D => y[1] & w
    // C (y[2]) --1--> D => y[2] & w
    // E (y[4]) --1--> D => y[4] & w
    // F (y[5]) --1--> D => y[5] & w
    // So Y3 = (y[1] | y[2] | y[4] | y[5]) & w

    assign Y1 = y[0] & ~w;
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule