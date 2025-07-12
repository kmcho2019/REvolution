module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next state input for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D)
    // Using De Morgan: Y3 = ~w & ~y[0] & ~y[3]
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    NextStateInput ns(
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule