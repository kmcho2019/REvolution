module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Assign A_equal first
    assign A_equal = (A == B);
    
    // Use explicit comparisons to determine A_greater and A_less
    assign A_greater = (~A_equal) && (A[3:0] > B[3:0]);
    assign A_less = (~A_equal) && (A[3:0] < B[3:0]);

endmodule