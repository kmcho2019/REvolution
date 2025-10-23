module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff;
wire borrow;

assign diff = A - B;
assign borrow = (A[3] == 0 && B[3] == 1) || 
                (A[3] == 1 && A[2:0] == 4'b0000 && B[3:2] == 2'b10 && B[1:0] != 2'b00) ||
                (A[2] == 0 && B[2] == 1 && A[3] == 1 && B[3] == 0) ||
                (A[2] == 1 && A[1:0] == 2'b00 && B[2:1] == 2'b10 && B[0] != 1'b0) ||
                (A[1] == 0 && B[1] == 1 && A[2] == 1 && B[2] == 0 && A[3] == 1 && B[3] == 0) ||
                (A[1] == 1 && A[0] == 0 && B[1] == 1 && B[0] == 1 && A[2] == 1 && B[2] == 0 && A[3] == 1 && B[3] == 0);

assign A_greater = (diff > 4'b0000) && !borrow;
assign A_equal = (diff == 4'b0000) && !borrow;
assign A_less = borrow || (diff < 4'b0000);

endmodule