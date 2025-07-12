module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire ny0 = ~y[0];
    wire ny3 = ~y[3];
    wire nw  = ~w;

    assign Y1 = y[0] & w;
    assign Y3 = nw & ny0 & ny3;

endmodule