module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation: A - B
wire [3:0] diff;
wire borrow;

// Subtract B from A
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign diff[3] = A[3] ^ B[3] ^ borrow;

// Determine borrow
assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || 
                 (A[0] == 1'b1 && B[0] == 1'b1 && A[1] == 1'b0 && B[1] == 1'b1) ||
                 (A[0] == 1'b1 && B[0] == 1'b1 && A[1] == 1'b1 && B[1] == 1'b1 && A[2] == 1'b0 && B[2] == 1'b1) ||
                 (A[0] == 1'b1 && B[0] == 1'b1 && A[1] == 1'b1 && B[1] == 1'b1 && A[2] == 1'b1 && B[2] == 1'b1 && A[3] == 1'b0 && B[3] == 1'b1);

// Determine output signals based on result of subtraction and borrow
assign A_greater = (~borrow && (diff[3] == 1'b1 || diff[2] == 1'b1 || diff[1] == 1'b1 || diff[0] == 1'b1));
assign A_equal = (~borrow && ~(diff[3] == 1'b1 || diff[2] == 1'b1 || diff[1] == 1'b1 || diff[0] == 1'b1));
assign A_less = borrow;

endmodule