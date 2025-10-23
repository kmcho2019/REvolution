module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (x[1]^x[0])) |  // Group a
               (x[3] & x[2] & ~(~x[1] & x[0])) |  // Group b
               (x[3] & ~x[2] & ~(x[1] & x[0]));   // Group c
endmodule