module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Perform subtraction A - B and check for borrow
wire [3:0] diff;
wire borrow;

// Subtraction logic with borrow
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign borrow = (A[0] == 0 && B[0] == 1) ? 1'b1 : (A[0] == 1 && B[0] == 0 && borrow == 1) ? 1'b1 : 0;

// For 4-bit, implement full borrow chain
assign diff[1] = A[1] ^ B[1] ^ ((A[0] == 0 && B[0] == 1) ? 1'b1 : (A[0] == 1 && B[0] == 0 && borrow == 1) ? 1'b1 : 0);
assign diff[2] = A[2] ^ B[2] ^ ((A[1] == 0 && B[1] == 1 && (A[0] == 0 && B[0] == 1 || (A[0] == 1 && B[0] == 0 && borrow == 1))) ? 1'b1 : (A[1] == 1 && B[1] == 0 && ((A[0] == 0 && B[0] == 1) || (A[0] == 1 && B[0] == 0 && borrow == 1)) && borrow == 1) ? 1'b1 : 0);
assign diff[3] = A[3] ^ B[3] ^ ((A[2] == 0 && B[2] == 1 && (A[1] == 0 && B[1] == 1 && (A[0] == 0 && B[0] == 1 || (A[0] == 1 && B[0] == 0 && borrow == 1)))) ? 1'b1 : (A[2] == 1 && B[2] == 0 && ((A[1] == 0 && B[1] == 1 && (A[0] == 0 && B[0] == 1 || (A[0] == 1 && B[0] == 0 && borrow == 1))) || (A[1] == 1 && B[1] == 0 && ((A[0] == 0 && B[0] == 1) || (A[0] == 1 && B[0] == 0 && borrow == 1)) && borrow == 1)) && borrow == 1) ? 1'b1 : 0);

// Check result to determine A_greater, A_equal, A_less
always @(A or B) begin
    if (A == B) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else if (A > B) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule