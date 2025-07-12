module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtraction with borrow_in = 0
    assign diff[0]   = A[0] ^ B[0];
    assign borrow0   = (~A[0] & B[0]);

    // Bit 1 subtraction with borrow0 as borrow_in
    assign diff[1]   = A[1] ^ B[1] ^ borrow0;
    assign borrow1   = ((~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow0));

    // Bit 2 subtraction with borrow1 as borrow_in
    assign diff[2]   = A[2] ^ B[2] ^ borrow1;
    assign borrow2   = ((~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow1));

    // Bit 3 subtraction with borrow2 as borrow_in
    assign diff[3]   = A[3] ^ B[3] ^ borrow2;
    assign borrow3   = ((~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow2));

    // borrow3 is the final borrow_out (1 if A < B)
    // diff is the subtraction result A - B

    // Check if diff is zero (all bits zero means A == B)
    wire diff_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    assign A_less    = borrow3;
    assign A_equal   = diff_zero;
    assign A_greater = (~borrow3) & (~diff_zero);

endmodule