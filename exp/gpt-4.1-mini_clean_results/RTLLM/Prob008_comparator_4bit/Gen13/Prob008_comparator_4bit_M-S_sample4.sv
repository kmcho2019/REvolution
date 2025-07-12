module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff;

    // Perform subtraction A - B using 5-bit signed arithmetic
    assign diff = {1'b0, A} + {1'b1, ~B} + 1'b1; // two's complement of B with carry-in 1

    // Equality detection
    wire equal = (A == B);

    // Sign bit of difference: 1 means negative (A < B), 0 means A >= B
    wire less = diff[4];

    // Assign outputs - mutually exclusive
    assign A_equal   = equal;
    assign A_less    = ~equal & less;
    assign A_greater = ~equal & ~less;

endmodule