module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire y0_n = ~y[0];
    wire y3_n = ~y[3];

    // Next state input for state B (y[1])
    assign Y1 = y[0] & w;

    // Next state input for state D (y[3])
    assign Y3 = w_n & y0_n & y3_n;
endmodule