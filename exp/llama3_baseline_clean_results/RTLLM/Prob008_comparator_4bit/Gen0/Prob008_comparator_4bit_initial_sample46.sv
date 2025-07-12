module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and check for borrow
wire [3:0] diff;
wire borrow;

// Subtraction operation
assign diff = A - B;
assign borrow = (A[3] == 1'b0 && B[3] == 1'b1) || 
                (A[2:1] == 2'b00 && B[2:1] == 2'b10 && A[0] == 1'b0 && B[0] == 1'b1) ||
                (A[2] == 1'b0 && B[2] == 1'b1 && A[1:0] == 2'b00 && B[1:0] == 2'b11) ||
                (A[1] == 1'b0 && B[1] == 1'b1 && A[0] == 1'b0 && B[0] == 1'b1);

// Determine output based on subtraction result
assign A_greater = (diff[3] == 1'b0) && (diff != 4'b0000) && (!borrow);
assign A_equal = (diff == 4'b0000) && (!borrow);
assign A_less = borrow;

endmodule