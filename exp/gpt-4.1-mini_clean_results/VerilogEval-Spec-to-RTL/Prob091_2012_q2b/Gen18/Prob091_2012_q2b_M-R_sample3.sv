module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: next-state input for B (y[1])
    // Transition from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: next-state input for D (y[3])
    // Transition occurs when w=0 from states B(y[1]), C(y[2]), E(y[4]), F(y[5])
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule