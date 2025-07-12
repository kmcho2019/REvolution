module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Arithmetic comparison approach
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    
    // MSB of diff indicates borrow (A < B)
    wire borrow = diff[4];
    
    // Greater than when no borrow and not equal
    wire greater = ~borrow & (|diff[3:0]);
    
    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;  // Implicit from borrow

endmodule