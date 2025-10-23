module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Arithmetic comparison approach
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    
    // Output assignments
    assign A_equal = (A == B);
    assign A_greater = ~A_equal & ~diff[4];  // No borrow means A >= B (and we know not equal)
    assign A_less = ~A_equal & diff[4];      // Borrow means A < B

endmodule