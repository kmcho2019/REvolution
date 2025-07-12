module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] diff;
assign diff = A - B;

// Check for borrow (A_less)
assign A_less = (B[3] == 1 && A[3] == 0) || 
               (B[2] == 1 && A[2] == 0 && B[3] == 0 && A[3] == 0) || 
               (B[1] == 1 && A[1] == 0 && B[3:2] == 2'b00 && A[3:2] == 2'b00) || 
               (B[0] == 1 && A[0] == 0 && B[3:1] == 3'b000 && A[3:1] == 3'b000);

// Check for equality (A_equal)
assign A_equal = (diff == 4'b0000);

// Check for greater than (A_greater)
assign A_greater = (~A_less && ~A_equal);

endmodule