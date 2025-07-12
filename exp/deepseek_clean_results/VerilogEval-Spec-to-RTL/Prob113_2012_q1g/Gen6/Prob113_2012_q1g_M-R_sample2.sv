module TopModule(
    input [3:0] x,
    output f
);
    // x[3:2] = 00 cases (f=1 when x[1:0] is 00 or 10)
    wire case00 = (~x[3] & ~x[2]) & ((~x[1] & ~x[0]) | (x[1] & ~x[0]));

    // x[3:2] = 11 cases (f=1 when x[1:0] is 00, 01, or 11)
    wire case11 = (x[3] & x[2]) & ((~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & x[0]));

    // x[3:2] = 10 cases (f=1 when x[1:0] is 00, 01, or 10)
    wire case10 = (x[3] & ~x[2]) & ((~x[1] & ~x[0]) | (~x[1] & x[0]) | (x[1] & ~x[0]));

    // Combine all cases where f should be 1
    assign f = case00 | case11 | case10;
endmodule