module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: next input for y[1], transition A -> B with w=1
    assign Y1 = y[0] & w;

    // Y3: next input for y[3] (state D)
    // Derived from FSM transitions leading to D:
    // B(1), C(2), F(5) states with w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[5]);

endmodule