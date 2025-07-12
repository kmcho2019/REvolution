module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Arithmetic comparison using subtraction
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    
    // Extract comparison signals from subtraction result
    wire equal = (diff[3:0] == 4'b0);
    wire greater = ~diff[4];  // No borrow means A >= B
    wire less = diff[4];     // Borrow means A < B

    // Final outputs (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater & ~equal;
    assign A_less = less;

endmodule