module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Equality check (fastest operation)
    wire equal = (A == B);
    
    // Optimized magnitude comparison (MSB-first with early termination)
    wire greater = (A > B);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule