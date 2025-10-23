module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next-state input for state B (y[1]): from A (y[0]) with w=1
    assign Y1 = y[0] & w;

    // Next-state input for state D (y[3]):
    // According to FSM, D is entered from B, C, E, F when w=0
    // So Y3 = ~w & (y[1] | y[2] | y[4] | y[5])
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

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