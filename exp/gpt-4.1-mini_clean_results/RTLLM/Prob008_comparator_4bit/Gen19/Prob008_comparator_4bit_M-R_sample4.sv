module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;       // Difference bits
    wire [4:0] borrow;     // Borrow signals between bits, borrow[0] = 0 initial
    
    assign borrow[0] = 1'b0; // No initial borrow

    // Bit 0 subtraction: A[0] - B[0] - borrow[0]
    assign diff[0]   = A[0] ^ B[0] ^ borrow[0];
    assign borrow[1] = (~A[0] & (B[0] | borrow[0])) | (B[0] & borrow[0]);

    // Bit 1 subtraction
    assign diff[1]   = A[1] ^ B[1] ^ borrow[1];
    assign borrow[2] = (~A[1] & (B[1] | borrow[1])) | (B[1] & borrow[1]);

    // Bit 2 subtraction
    assign diff[2]   = A[2] ^ B[2] ^ borrow[2];
    assign borrow[3] = (~A[2] & (B[2] | borrow[2])) | (B[2] & borrow[2]);

    // Bit 3 subtraction
    assign diff[3]   = A[3] ^ B[3] ^ borrow[3];
    assign borrow[4] = (~A[3] & (B[3] | borrow[3])) | (B[3] & borrow[3]);

    // Borrow out borrow[4] indicates A < B
    wire a_less = borrow[4];

    // Equality: all diff bits zero means A == B (when borrow=0 too)
    wire a_equal = (borrow[4] == 1'b0) && (diff == 4'b0000);

    // A greater if no borrow and diff != 0
    wire a_greater = (borrow[4] == 1'b0) && (diff != 4'b0000);

    assign A_less    = a_less;
    assign A_equal   = a_equal;
    assign A_greater = a_greater;

endmodule