module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal signal to store the result of subtraction
    wire [3:0] diff;

    // Perform subtraction A - B using combinational logic
    assign diff[0] = A[0] ^ B[0] ^ 1'b1;
    assign diff[1] = A[1] ^ B[1] ^ (A[0] & ~B[0]);
    assign diff[2] = A[2] ^ B[2] ^ ((A[1] & ~B[1]) | (A[0] & ~B[0] & ~B[1]));
    assign diff[3] = A[3] ^ B[3] ^ (((A[2] & ~B[2]) | (A[1] & ~B[1] & ~B[2]) | (A[0] & ~B[0] & ~B[1] & ~B[2])));

    // Determine if A is greater than B (no borrow and non-zero result)
    assign A_greater = ~(diff[3] ^ 1'b1) & ~(diff[0] & ~B[0]) & ~(diff[1] & ~B[1]) & ~(diff[2] & ~B[2]) & (|diff);

    // Determine if A is equal to B (result of subtraction is zero)
    assign A_equal = ~(|diff) & ~(diff[3] ^ 1'b1) & ~(diff[0] & ~B[0]) & ~(diff[1] & ~B[1]) & ~(diff[2] & ~B[2]);

    // Determine if A is less than B (borrow occurred)
    assign A_less = (diff[3] ^ 1'b1) | (diff[0] & ~B[0]) | (diff[1] & ~B[1]) | (diff[2] & ~B[2]);

endmodule