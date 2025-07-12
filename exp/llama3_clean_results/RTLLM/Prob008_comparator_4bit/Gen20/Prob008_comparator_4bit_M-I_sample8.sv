module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;

    assign diff[3] = A[3] ^ B[3];
    assign diff[2] = A[2] ^ B[2];
    assign diff[1] = A[1] ^ B[1];
    assign diff[0] = A[0] ^ B[0];

    assign A_equal = ~(diff[3] | diff[2] | diff[1] | diff[0]);

    assign A_greater = (~A_equal) & ((A[3] & ~B[3]) | 
                                    (A[2] & ~B[2] & ~(A[3] ^ B[3])) | 
                                    (A[1] & ~B[1] & ~(A[3] ^ B[3]) & ~(A[2] ^ B[2])) | 
                                    (A[0] & ~B[0] & ~(A[3] ^ B[3]) & ~(A[2] ^ B[2]) & ~(A[1] ^ B[1])));

    assign A_less = (~A_equal) & (~A_greater);

    // Additional optimization: using a single output signal to indicate the comparison result
    // assign result = {A_greater, A_equal, A_less};

endmodule