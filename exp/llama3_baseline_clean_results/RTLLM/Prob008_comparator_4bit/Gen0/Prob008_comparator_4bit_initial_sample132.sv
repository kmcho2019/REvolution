module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Calculate A - B
wire [3:0] diff;
assign diff = A - B;

// Check for borrow
wire borrow;
assign borrow = (A[3] == 1'b0 && B[3] == 1'b1) ||
                (A[3] == 1'b0 && A[2:0] != 0 && B[2:0] == 4'b1111) ||
                (A[2:1] == 2'b00 && A[0] == 1'b0 && B[2:0] == 3'b111) ||
                (A[1:0] == 2'b00 && A[0] == 1'b0 && B[1:0] == 2'b11);

// Generate output signals
assign A_greater = (~borrow && diff != 0);
assign A_equal = (diff == 0 && ~borrow);
assign A_less = borrow;

endmodule