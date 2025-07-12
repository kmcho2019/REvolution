module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtractor: A0 - B0 - borrow_in (borrow_in = 0)
    assign diff[0] = A[0] ^ B[0];
    assign borrow0 = (~A[0] & B[0]);

    // Bit 1 subtractor: A1 - B1 - borrow0
    assign diff[1] = A[1] ^ B[1] ^ borrow0;
    assign borrow1 = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow0);

    // Bit 2 subtractor: A2 - B2 - borrow1
    assign diff[2] = A[2] ^ B[2] ^ borrow1;
    assign borrow2 = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow1);

    // Bit 3 subtractor: A3 - B3 - borrow2
    assign diff[3] = A[3] ^ B[3] ^ borrow2;
    assign borrow3 = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow2);

    // Equal if all diff bits are zero
    wire equal = ~( |diff );  // NOR reduction of diff bits

    // A less than B if borrow out of MSB subtractor is 1
    wire less = borrow3;

    // A greater than B if not less and not equal
    wire greater = ~less & ~equal;

    assign A_equal   = equal;
    assign A_less    = less;
    assign A_greater = greater;

endmodule