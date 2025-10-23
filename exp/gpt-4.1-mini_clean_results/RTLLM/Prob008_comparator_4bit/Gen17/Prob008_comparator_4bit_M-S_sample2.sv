module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff = {1'b0, A} - {1'b0, B};  // 5-bit subtraction to get borrow out

    wire borrow_out = diff[4];
    wire equal = (A ^ B) == 4'b0000;

    assign A_less    = borrow_out;
    assign A_equal   = equal;
    assign A_greater = ~borrow_out & ~equal;

endmodule