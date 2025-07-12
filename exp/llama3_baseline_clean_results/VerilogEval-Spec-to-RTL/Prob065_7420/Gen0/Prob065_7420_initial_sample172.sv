module TopModule(p1a, p1b, p1c, p1d, p2a, p2b, p2c, p2d, p1y, p2y);
    input p1a, p1b, p1c, p1d;
    input p2a, p2b, p2c, p2d;
    output p1y, p2y;

    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule