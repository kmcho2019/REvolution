module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [4:0] diff = {1'b0, A} - {1'b0, B};  // 5-bit subtraction to capture borrow
    
    assign A_less = diff[4];                  // Borrow indicates A < B
    assign A_equal = (A == B);                // Direct equality comparison
    assign A_greater = ~A_less & ~A_equal;    // Neither less nor equal means greater

endmodule