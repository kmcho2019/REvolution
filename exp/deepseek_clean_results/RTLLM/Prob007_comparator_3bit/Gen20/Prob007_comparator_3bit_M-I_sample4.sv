module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct magnitude comparison (synthesis tools optimize this well)
    assign A_greater = (A > B);
    assign A_equal = (A == B);
    assign A_less = (A < B);

    // Alternative implementation with explicit logic for reference:
    // assign A_greater = (A[2] > B[2]) | 
    //                   ((A[2] == B[2]) & (A[1] > B[1])) |
    //                   ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] > B[0]));
    // assign A_equal = (A[2] == B[2]) & (A[1] == B[1]) & (A[0] == B[0]);
    // assign A_less = ~A_greater & ~A_equal;

endmodule