module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Y2 is next state for y[1] (state B)
    assign Y2 = (~w & y[0]) | (~w & y[5]);

    // Y4 is next state for y[3] (state D)
    assign Y4 = (w & y[1]) | (w & y[2]) | (w & y[3]) | (w & y[4]) | (w & y[5]);

endmodule