module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire states_for_D = y[1] | y[2] | y[4] | y[5];

    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Factor common OR for Y3, then AND with ~w
    assign Y3 = states_for_D & w_n;
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