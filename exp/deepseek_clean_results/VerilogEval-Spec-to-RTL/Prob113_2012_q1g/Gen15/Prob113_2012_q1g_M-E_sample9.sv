module TopModule(
    input [3:0] x,
    output f
);
    wire case1 = ~x[3] & ~(x[1] ^ x[0]);  // x[3:2]=00 and x[1]=x[0]
    wire case2 = x[3] & (x[2] | ~x[1]);    // x[3:2]=11 or 10 with conditions
    assign f = case1 | case2;
endmodule