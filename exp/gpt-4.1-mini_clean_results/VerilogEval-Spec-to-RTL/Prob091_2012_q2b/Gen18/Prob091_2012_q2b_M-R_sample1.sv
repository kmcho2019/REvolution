module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next-state input for state B (y[1]):
    // Transition from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Next-state input for state D (y[3]):
    // From the FSM logic: Y3 = ~w & ~y[0] & ~y[3]
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule