module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality check using XNOR and reduction AND
    assign A_equal = &(~(A ^ B));

    // Embedded greater-than comparison
    assign A_greater = (A[3] > B[3]) |
                      ((A[3] == B[3]) & (A[2] > B[2])) |
                      ((A[3:2] == B[3:2]) & (A[1] > B[1])) |
                      ((A[3:1] == B[3:1]) & (A[0] > B[0]));

    // Less-than is the remaining case
    assign A_less = ~(A_equal | A_greater);

endmodule