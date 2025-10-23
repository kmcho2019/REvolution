module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// A greater than B
assign A_greater = (A > B) ? 1'b1 : 1'b0;

// A equal to B
assign A_equal = (A == B) ? 1'b1 : 1'b0;

// A less than B
assign A_less = (A < B) ? 1'b1 : 1'b0;

// Alternative implementation for better understanding of the logic
// assign A_greater = (A[2] && ~B[2]) || (A[2] == B[2] && A[1] && ~B[1]) || (A[2] == B[2] && A[1] == B[1] && A[0] && ~B[0]);
// assign A_equal = (A[2] == B[2] && A[1] == B[1] && A[0] == B[0]);
// assign A_less = ~A_greater && ~A_equal;

endmodule