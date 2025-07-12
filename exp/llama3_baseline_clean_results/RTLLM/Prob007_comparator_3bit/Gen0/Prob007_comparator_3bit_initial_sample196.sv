module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Compare A and B for equality
    assign A_equal = (A == B);
    
    // If A is not equal to B, compare A and B to determine if A is greater than B
    assign A_greater = (A > B);
    
    // If A is not equal to B, compare A and B to determine if A is less than B
    assign A_less = (A < B);

endmodule