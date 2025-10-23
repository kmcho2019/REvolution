module TopModule(
    input [3:0] x,
    output f
);
    assign f = x[1] | (~x[2] & ~x[0]);
endmodule