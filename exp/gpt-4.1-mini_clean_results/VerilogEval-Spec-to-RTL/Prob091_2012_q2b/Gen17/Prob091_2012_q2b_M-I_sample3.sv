module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire y0_n = ~y[0];
    wire y3_n = ~y[3];

    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input logic for y[3] (state D)
    // Using AND of inverted signals to avoid NOR gate:
    // Y3 = ~w & ~y[0] & ~y[3]
    assign Y3 = w_n & y0_n & y3_n;
endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    NextStateInput ns_inst(
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );
endmodule