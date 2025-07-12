module TopModule(
    input [3:0] x,
    output f
);
    wire term1, term2, term3;
    
    // Term1: x[3:2]=00 AND (x[1:0]=00 OR x[1:0]=10)
    assign term1 = ~x[3] & ~x[2] & ((~x[1] & ~x[0]) | (x[1] & ~x[0]));
    
    // Term2: x[3:2]=11 AND (x[1] OR x[0])
    assign term2 = x[3] & x[2] & (x[1] | x[0]);
    
    // Term3: x[3:2]=10 AND (x[1:0]!=11)
    assign term3 = x[3] & ~x[2] & ~(x[1] & x[0]);
    
    // Final output is OR of all terms
    assign f = term1 | term2 | term3;
endmodule