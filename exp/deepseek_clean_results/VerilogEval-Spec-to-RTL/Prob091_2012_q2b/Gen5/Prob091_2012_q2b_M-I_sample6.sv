module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Transition from A (y[0]) to B when w=1
    assign Y1 = y[0] & w;

    // Y3: Transition to D (y[3]) when:
    // - In states B(y[1]), C(y[2]), E(y[4]), or F(y[5])
    // - And w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule