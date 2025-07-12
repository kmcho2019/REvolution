module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff = {1'b0, A} - {1'b0, B};  // 5-bit subtraction to get borrow in MSB

    assign A_equal   = (diff[3:0] == 4'b0000);
    assign A_less    = diff[4];                // borrow = 1 means A < B
    assign A_greater = ~diff[4] & ~A_equal;   // no borrow and not equal means A > B

endmodule