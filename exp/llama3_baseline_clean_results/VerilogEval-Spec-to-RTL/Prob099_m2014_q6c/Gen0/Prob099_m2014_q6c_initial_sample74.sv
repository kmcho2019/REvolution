module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3,
    output Y2,
    output Y4
);

    assign Y1 = y[0];
    assign Y2 = y[0] & ~w;
    assign Y3 = y[2];
    assign Y4 = (y[1] | y[2] | y[4]) & w;

endmodule