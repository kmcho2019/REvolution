module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Comparison logic
assign A_greater = (A > B) ? 1'b1 : 1'b0;
assign A_equal = (A == B) ? 1'b1 : 1'b0;
assign A_less = (A < B) ? 1'b1 : 1'b0;

// Alternatively, you can also write the comparison logic using individual bit comparisons
// assign A_greater = (A[2] > B[2]) || (A[2] == B[2] && A[1] > B[1]) || (A[2] == B[2] && A[1] == B[1] && A[0] > B[0]);
// assign A_equal = (A[2] == B[2]) && (A[1] == B[1]) && (A[0] == B[0]);
// assign A_less = (A[2] < B[2]) || (A[2] == B[2] && A[1] < B[1]) || (A[2] == B[2] && A[1] == B[1] && A[0] < B[0]);

endmodule