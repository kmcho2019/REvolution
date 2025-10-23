module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3 = NOR3(w, y[0], y[3]) = (~w) & (~y[0]) & (~y[3])
    assign Y3 = ~(w | y[0] | y[3]);
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