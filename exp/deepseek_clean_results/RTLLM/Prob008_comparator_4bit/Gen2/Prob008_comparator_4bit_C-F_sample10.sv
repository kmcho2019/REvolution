module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality - most efficient way to check equality
    wire equal = (A == B);
    
    // Magnitude comparison only needed if not equal
    wire greater = ~equal & (
        (A[3] > B[3]) |
        ((A[3] == B[3]) & (A[2] > B[2])) |
        ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] > B[1])) |
        ((A[3] == B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (A[0] > B[0]))
    );

    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule