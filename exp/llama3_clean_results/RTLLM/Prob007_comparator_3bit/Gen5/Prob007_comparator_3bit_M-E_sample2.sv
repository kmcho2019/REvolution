module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

wire [2:0] diff;
wire borrow;

assign diff = A - B;
assign borrow = (A[2] == 0 && B[2] == 1) || (A[2] == 0 && A[1:0] > B[1:0] && B[2] == 0);

always @(*) begin
    A_greater = (diff > 0 && !borrow) ? 1'b1 : 1'b0;
    A_equal = (diff == 0) ? 1'b1 : 1'b0;
    A_less = (diff < 0 || borrow) ? 1'b1 : 1'b0;
end

endmodule