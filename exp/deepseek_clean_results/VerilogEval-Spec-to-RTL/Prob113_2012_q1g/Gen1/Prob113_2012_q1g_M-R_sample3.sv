module TopModule(
    input [3:0] x,
    output f
);
    wire group1 = ~x[3] & ~x[2] & ~x[0];
    wire group2 = x[3] & x[2] & ~x[1];
    wire group3 = (x[3] & ~x[2] & ~x[1]) | (x[3] & ~x[2] & ~x[0]);
    
    assign f = group1 | group2 | group3;
endmodule