module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate borrow
wire [3:0] diff;
wire borrow;

// 4-bit subtractor circuit
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || (A[0] == 1'b1 && B[0] == 1'b1 && borrow);

// Repeat for higher bits
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign borrow = (A[1] == 1'b0 && B[1] == 1'b1) || (A[1] == 1'b1 && B[1] == 1'b1 && borrow);

assign diff[2] = A[2] ^ B[2] ^ borrow;
assign borrow = (A[2] == 1'b0 && B[2] == 1'b1) || (A[2] == 1'b1 && B[2] == 1'b1 && borrow);

assign diff[3] = A[3] ^ B[3] ^ borrow;
assign borrow = (A[3] == 1'b0 && B[3] == 1'b1) || (A[3] == 1'b1 && B[3] == 1'b1 && borrow);

// Determine outputs based on result and borrow
assign A_greater = ~borrow && (diff[3] == 1'b1 || diff[2] == 1'b1 || diff[1] == 1'b1 || diff[0] == 1'b1);
assign A_equal = ~borrow && ~(|diff);  // if diff is all zeros
assign A_less = borrow;

endmodule