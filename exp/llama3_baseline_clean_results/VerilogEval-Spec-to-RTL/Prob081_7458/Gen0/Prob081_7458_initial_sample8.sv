module TopModule(
    input p1a, p1b, p1c,
    input p1d, p1e, p1f,
    input p2a, p2b,
    input p2c, p2d,
    output p1y,
    output p2y
);

assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p2y = (p2a & p2b) | (p2c & p2d);

endmodule