module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct output computation without intermediate wires
    assign A_greater = (A[2] > B[2]) | 
                      ((A[2] == B[2]) & (A[1] > B[1])) | 
                      ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] > B[0]));

    assign A_equal = (A[2] == B[2]) & (A[1] == B[1]) & (A[0] == B[0]);

    // More efficient than separate comparison logic
    assign A_less = ~(A_greater | A_equal);

endmodule