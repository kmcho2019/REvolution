module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output      A_greater,
    output      A_equal,
    output      A_less
);

    wire [3:0] diff;
    assign diff = A - B;

    assign A_greater = (diff > 0);
    assign A_equal = (diff == 0);
    assign A_less = (diff < 0);

    // Alternative implementation using bitwise comparison tree
    // wire msb_cmp;
    // assign msb_cmp = (A[3] > B[3]) | (A[3] == B[3] & (A[2] > B[2])) | 
    //                  (A[3] == B[3] & A[2] == B[2] & (A[1] > B[1])) | 
    //                  (A[3] == B[3] & A[2] == B[2] & A[1] == B[1] & (A[0] > B[0]));

    // assign A_greater = msb_cmp;
    // assign A_equal = (A == B);
    // assign A_less = ~A_greater & ~A_equal;

endmodule