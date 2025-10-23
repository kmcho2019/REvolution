module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire w_n = ~w;
    wire or_y1y2y4y5 = y[1] | y[2] | y[4] | y[5];

    // Next input for y[1] flip-flop (state B)
    assign Y1 = y[0] & w;

    // Next input for y[3] flip-flop (state D)
    assign Y3 = w_n & or_y1y2y4y5;

endmodule