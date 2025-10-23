module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire [4:0] diff_ext;
assign diff_ext = {1'b0, A} - {1'b0, B}; // 5-bit subtraction to detect borrow in MSB

wire borrow = diff_ext[4]; // MSB borrow: 1 if A < B
wire result_zero = (diff_ext[3:0] == 4'b0000);

assign A_less    = borrow;
assign A_equal   = ~borrow & result_zero;
assign A_greater = ~borrow & ~result_zero;

endmodule