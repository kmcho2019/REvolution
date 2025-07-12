module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is next state for y[1] (state B)
    assign Y1 = (~w & y[0]) | (~w & y[5]);

    // Y3 is next state for y[3] (state D)
    assign Y3 = (w & y[1]) | (w & y[2]) | (w & y[3]) | (w & y[4]) | (w & y[5]);

endmodule