module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff;
    wire [3:0] borrow;

    // Full subtractor for bit 0 (LSB)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0] & B[0]);

    // Full subtractor for bit 1
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow[0]);

    // Full subtractor for bit 2
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow[1]);

    // Full subtractor for bit 3 (MSB)
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow[2]);

    wire diff_zero = (diff == 4'b0000);
    wire borrow_out = borrow[3];

    assign A_less    = borrow_out;
    assign A_equal   = ~borrow_out & diff_zero;
    assign A_greater = ~borrow_out & ~diff_zero;

endmodule