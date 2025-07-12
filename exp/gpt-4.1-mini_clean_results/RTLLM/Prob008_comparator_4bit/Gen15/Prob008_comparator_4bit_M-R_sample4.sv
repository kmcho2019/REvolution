module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire b0, b1, b2, b3;      // borrow signals between bits
    wire [3:0] diff;          // difference bits (not used in output, but calculated for clarity)

    // Bit 0 subtraction: A[0] - B[0] - borrow_in (borrow_in = 0)
    assign diff[0] = A[0] ^ B[0];
    assign b0 = (~A[0] & B[0]);

    // Bit 1 subtraction: A[1] - B[1] - b0
    assign diff[1] = A[1] ^ B[1] ^ b0;
    assign b1 = ((~A[1] & B[1]) | ((~A[1] | B[1]) & b0));

    // Bit 2 subtraction: A[2] - B[2] - b1
    assign diff[2] = A[2] ^ B[2] ^ b1;
    assign b2 = ((~A[2] & B[2]) | ((~A[2] | B[2]) & b1));

    // Bit 3 subtraction: A[3] - B[3] - b2
    assign diff[3] = A[3] ^ B[3] ^ b2;
    assign b3 = ((~A[3] & B[3]) | ((~A[3] | B[3]) & b2));

    // Determine equality using reduction equality operator
    assign A_equal = (A == B);

    // Final borrow out indicates A < B
    assign A_less = b3;

    // If not less and not equal, then A > B
    assign A_greater = ~(A_less | A_equal);

endmodule