module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire [2:0] borrow;  // Intermediate borrow signals
    wire borrow_out;

    // 4-bit subtractor with borrow chain
    assign diff[0] = A[0] ^ B[0] ^ 1'b1;         // A - B is same as A + ~B + 1
    assign borrow[0] = (~A[0] & B[0]) | (~A[0] & 1'b1) | (B[0] & 1'b1);

    assign diff[1] = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | (~A[1] & borrow[0]) | (B[1] & borrow[0]);

    assign diff[2] = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | (~A[2] & borrow[1]) | (B[2] & borrow[1]);

    assign diff[3] = A[3] ^ B[3] ^ borrow[2];
    assign borrow_out = (~A[3] & B[3]) | (~A[3] & borrow[2]) | (B[3] & borrow[2]);

    // Output logic
    assign A_equal = (diff == 4'b0000) & ~borrow_out;
    assign A_greater = (diff != 4'b0000) & ~borrow_out;
    assign A_less = borrow_out;

endmodule