module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [4:0] diff = {1'b0, A} - {1'b0, B};
wire borrow = diff[4];
wire zero = ~|diff[3:0];

assign A_less = borrow;
assign A_equal = zero;
assign A_greater = ~borrow & ~zero;

endmodule