module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff = {1'b0, A} - {1'b0, B};  // 4-bit subtraction to handle borrow

assign A_greater = ~diff[3];  // Positive difference means A > B
assign A_equal = (diff[2:0] == 3'b0);  // Zero difference means equal
assign A_less = diff[3];  // Negative difference means A < B

endmodule