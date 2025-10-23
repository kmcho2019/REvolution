module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // f is true when:
    // (x3 is 0 AND x2 is 1) OR (x3 is 1 AND x1 is 1)
    wire term1 = ~x3 & x2;  // First condition from truth table
    wire term2 = x3 & x1;   // Second condition from truth table
    
    assign f = term1 | term2;
endmodule