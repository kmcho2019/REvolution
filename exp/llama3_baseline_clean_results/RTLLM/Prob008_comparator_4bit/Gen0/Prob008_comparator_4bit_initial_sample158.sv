module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B
    wire [3:0] diff;
    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1];
    assign diff[2] = A[2] - B[2];
    assign diff[3] = A[3] - B[3];

    // Check for borrow (A is less than B)
    wire borrow;
    assign borrow = (A[0] < B[0]) | 
                    (A[0] == B[0] && A[1] < B[1]) | 
                    (A[0] == B[0] && A[1] == B[1] && A[2] < B[2]) | 
                    (A[0] == B[0] && A[1] == B[1] && A[2] == B[2] && A[3] < B[3]);

    // Check for no borrow and non-zero result (A is greater than B)
    assign A_greater = (~borrow) && (A[3:0] > B[3:0]);

    // Check for zero result (A is equal to B)
    assign A_equal = ~(borrow | A_greater) && (A[3:0] == B[3:0]);

    // A is less than B if borrow occurs
    assign A_less = borrow;

endmodule