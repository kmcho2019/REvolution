module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Subtraction result (4 bits)
    wire [3:0] diff;

    // Borrow signal (active-high when A < B)
    wire borrow;

    // Perform 4-bit subtraction (A - B) with borrow
    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1] - borrow;
    assign diff[2] = A[2] - B[2] - borrow;
    assign diff[3] = A[3] - B[3] - borrow;

    // Borrow generation
    assign borrow = (A[0] < B[0]) | ((A[0] == B[0]) & (A[1] < B[1])) | 
                    ((A[0:1] == B[0:1]) & (A[2] < B[2])) | 
                    ((A[0:2] == B[0:2]) & (A[3] < B[3]));

    // Determine relationship based on borrow and result
    assign A_less  = borrow;
    assign A_equal = ~borrow & (diff == 4'b0000);
    assign A_greater = ~borrow & ~(diff == 4'b0000);

endmodule