module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next-state input for state B (y[1]): from state A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Next-state input for state D (y[3]):
    // Using De Morgan's law:
    // Y3 = ~w & ~(y[0] | y[3]) = ~w & ~y[0] & ~y[3]
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate next-state input logic module
    NextStateInput ns(
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule