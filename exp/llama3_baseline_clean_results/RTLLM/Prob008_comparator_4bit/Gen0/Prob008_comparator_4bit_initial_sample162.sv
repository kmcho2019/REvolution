module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals to hold the borrow and result of subtraction
wire [3:0] result;
wire [3:1] borrow;

// Perform subtraction (A - B)
assign result[0] = A[0] ^ B[0] ^ borrow[0];
assign borrow[1] = (A[0] == 0 && B[0] == 1) || (A[0] == 0 && B[0] == 0 && borrow[0] == 1) || (A[0] == 1 && B[0] == 1 && borrow[0] == 1);
assign result[1] = A[1] ^ B[1] ^ borrow[1];
assign borrow[2] = (A[1] == 0 && B[1] == 1) || (A[1] == 0 && B[1] == 0 && borrow[1] == 1) || (A[1] == 1 && B[1] == 1 && borrow[1] == 1);
assign result[2] = A[2] ^ B[2] ^ borrow[2];
assign borrow[3] = (A[2] == 0 && B[2] == 1) || (A[2] == 0 && B[2] == 0 && borrow[2] == 1) || (A[2] == 1 && B[2] == 1 && borrow[2] == 1);
assign result[3] = A[3] ^ B[3] ^ borrow[3];

// Initialize the borrow signal for the least significant bit
assign borrow[0] = 1'b0;

// Determine the output based on the result of subtraction and borrow
assign A_greater = (borrow[3] == 0 && (result[3] == 1 || (result[3] == 0 && result[2] == 1) || (result[3] == 0 && result[2] == 0 && result[1] == 1) || (result[3] == 0 && result[2] == 0 && result[1] == 0 && result[0] == 1)));
assign A_equal = (borrow[3] == 0 && result[3] == 0 && result[2] == 0 && result[1] == 0 && result[0] == 0);
assign A_less = borrow[3];

endmodule