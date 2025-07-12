module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Determine A_greater
    assign A_greater = (A > B) ? 1'b1 : 1'b0;
    
    // Determine A_equal
    assign A_equal = (A == B) ? 1'b1 : 1'b0;
    
    // Determine A_less
    assign A_less = (A < B) ? 1'b1 : 1'b0;

endmodule