module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D)
    assign Y3 = (~w & (y[1] | y[2] | y[4] | y[5]));

endmodule