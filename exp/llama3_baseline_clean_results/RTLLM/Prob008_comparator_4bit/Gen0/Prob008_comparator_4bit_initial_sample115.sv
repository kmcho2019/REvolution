module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] result;
    wire borrow;

    // Perform subtraction A - B
    assign result[0] = A[0] ^ B[0] ^ borrow;
    assign result[1] = A[1] ^ B[1] ^ borrow;
    assign result[2] = A[2] ^ B[2] ^ borrow;
    assign result[3] = A[3] ^ B[3] ^ borrow;

    // Generate borrow
    assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) ||
                   (A[1] == 1'b0 && B[1] == 1'b1 && A[0] == B[0]) ||
                   (A[2] == 1'b0 && B[2] == 1'b1 && A[1:0] == B[1:0]) ||
                   (A[3] == 1'b0 && B[3] == 1'b1 && A[2:0] == B[2:0]);

    // Determine A_greater, A_equal, A_less
    assign A_greater = ~borrow && (|result);
    assign A_equal = ~borrow && ~(|result);
    assign A_less = borrow;

endmodule