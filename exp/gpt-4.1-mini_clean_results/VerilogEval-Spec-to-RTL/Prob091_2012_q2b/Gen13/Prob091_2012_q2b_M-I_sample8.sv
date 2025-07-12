module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Group states for logic factoring
    wire group1 = y[1] | y[2];  // States B or C
    wire group2 = y[4] | y[5];  // States E or F

    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Factor common OR groups for Y3, then AND with ~w
    assign Y3 = w_n & (group1 | group2);
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