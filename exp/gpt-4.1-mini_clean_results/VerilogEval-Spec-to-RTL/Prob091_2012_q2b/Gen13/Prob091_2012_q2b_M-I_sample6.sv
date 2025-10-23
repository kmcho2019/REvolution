module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input logic for y[3] (state D)
    // Simplify ~(y[0] | y[3]) to ~y[0] & ~y[3]
    assign Y3 = (~w) & (~y[0]) & (~y[3]);
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