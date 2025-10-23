module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Compare A and B
    assign A_greater = (A > B) ? 1'b1 : 1'b0;
    assign A_equal = (A == B) ? 1'b1 : 1'b0;
    assign A_less = (A < B) ? 1'b1 : 1'b0;

    // Alternatively, we can implement the comparison logic using bitwise operations
    // assign A_greater = (A[2:0] > B[2:0]) ? 1'b1 : 1'b0;
    // assign A_equal = (A[2:0] == B[2:0]) ? 1'b1 : 1'b0;
    // assign A_less = (A[2:0] < B[2:0]) ? 1'b1 : 1'b0;

endmodule