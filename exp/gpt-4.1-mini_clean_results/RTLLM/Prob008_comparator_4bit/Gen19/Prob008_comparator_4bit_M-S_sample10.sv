module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 5-bit subtraction: A - B, MSB is borrow
    wire [4:0] diff = {1'b0, A} - {1'b0, B};

    // Equality if lower 4 bits are zero
    wire equal_bits = (diff[3:0] == 4'b0000);

    // Borrow indicates A < B
    assign A_less    = diff[4];
    assign A_equal   = equal_bits;
    assign A_greater = ~diff[4] & ~equal_bits;

endmodule