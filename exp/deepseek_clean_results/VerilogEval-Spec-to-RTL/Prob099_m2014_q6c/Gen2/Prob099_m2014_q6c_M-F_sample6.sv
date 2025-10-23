module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is next state for y[0] (state A)
    assign Y1 = (w & y[0]) | (w & y[3]);

    // Y3 is next state for y[2] (state C)
    assign Y3 = (~w & y[1]) | (~w & y[5]);

endmodule