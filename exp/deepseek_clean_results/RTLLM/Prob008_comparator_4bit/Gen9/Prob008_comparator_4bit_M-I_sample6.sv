module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [4:0] diff;  // 5-bit to capture borrow (MSB) and 4-bit result

assign diff = {1'b0, A} - {1'b0, B};  // Zero-extended subtraction

assign A_less = diff[4];  // Borrow indicates A < B
assign A_equal = (diff[3:0] == 4'b0) & ~diff[4];
assign A_greater = (diff[3:0] != 4'b0) & ~diff[4];

endmodule