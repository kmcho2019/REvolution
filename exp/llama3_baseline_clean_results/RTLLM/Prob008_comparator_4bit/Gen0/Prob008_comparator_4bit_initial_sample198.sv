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
assign borrow = (A < B);

assign A_greater = (~borrow & (diff != 4'b0000));
assign A_equal = (diff == 4'b0000);
assign A_less = borrow;

endmodule