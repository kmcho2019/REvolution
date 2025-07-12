module TopModule(
    input [3:0] x,
    output f
);
    // x[3:2] = 00: f=1 when x[0]=0
    wire case00 = (~x[3] & ~x[2]) & ~x[0];

    // x[3:2] = 11: f=1 when ~x[1] or (x[1] & x[0])
    wire case11 = (x[3] & x[2]) & (~x[1] | (x[1] & x[0]));

    // x[3:2] = 10: f=1 when ~x[1] or (x[1] & ~x[0])
    wire case10 = (x[3] & ~x[2]) & (~x[1] | (x[1] & ~x[0]));

    // Combine all cases where f should be 1
    assign f = case00 | case11 | case10;
endmodule