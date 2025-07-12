module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    wire p1_and = p1a & p1b & p1c & p1d;
    wire p2_and = p2a & p2b & p2c & p2d;

    assign p1y = ~p1_and;
    assign p2y = ~p2_and;

endmodule