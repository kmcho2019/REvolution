module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    wire term1 = x[2] & ~x[0];          // First product term
    wire x3_and_x1 = x[3] & x[1];       // Common sub-expression
    wire x0_and_notx2 = x[0] & ~x[2];   // Second part of second term
    
    assign f = term1 | (x3_and_x1 & x0_and_notx2);
endmodule