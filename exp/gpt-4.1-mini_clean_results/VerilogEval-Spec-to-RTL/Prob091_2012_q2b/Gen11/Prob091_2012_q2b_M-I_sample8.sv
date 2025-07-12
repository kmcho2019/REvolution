module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Intermediate OR groups to reduce fan-in
    wire y12 = y[1] | y[2];
    wire y45 = y[4] | y[5];

    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input logic for y[3] (state D) with factored OR
    assign Y3 = w_n & (y12 | y45);
endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Instantiate combinational logic module for next state inputs
    NextStateInput ns_inst(
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );
endmodule