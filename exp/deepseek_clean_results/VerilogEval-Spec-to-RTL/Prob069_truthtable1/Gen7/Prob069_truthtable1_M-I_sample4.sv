module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement truth table using optimized Boolean expression:
    // f = (~x3 & x2) | (x3 & x1)
    wire term1 = ~x3 & x2;
    wire term2 = x3 & x1;
    assign f = term1 | term2;
endmodule