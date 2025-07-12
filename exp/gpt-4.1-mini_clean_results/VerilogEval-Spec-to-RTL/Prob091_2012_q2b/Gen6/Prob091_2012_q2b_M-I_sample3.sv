module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire y0_n = ~y[0];
    wire y3_n = ~y[3];

    // Y1 = y[0] & w (next input for state B flip-flop)
    assign Y1 = y[0] & w;

    // Y3 = (~w) & ~y[0] & ~y[3] (next input for state D flip-flop)
    assign Y3 = w_n & y0_n & y3_n;
endmodule