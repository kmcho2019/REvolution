module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire borrow;

    // Subtraction operation: A - B
    assign diff[0] = A[0] ^ B[0] ^ borrow;
    assign diff[1] = A[1] ^ B[1] ^ borrow;
    assign diff[2] = A[2] ^ B[2] ^ borrow;
    assign diff[3] = A[3] ^ B[3] ^ borrow;

    // Borrow calculation
    assign borrow = (A[0] == 0 && B[0] == 1) || 
                   (A[1:0] == 2'b01 && B[1:0] == 2'b10) || 
                   (A[2:0] == 3'b101 && B[2:0] == 3'b110) || 
                   (A[3:0] == 4'b1001 && B[3:0] == 4'b1010);

    // Determine outputs based on difference and borrow
    assign A_greater = (borrow == 0) && (diff != 4'b0000);
    assign A_equal   = (diff == 4'b0000);
    assign A_less    = borrow;

endmodule