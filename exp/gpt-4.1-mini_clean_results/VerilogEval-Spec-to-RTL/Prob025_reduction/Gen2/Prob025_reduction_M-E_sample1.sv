module TopModule (
    input  [7:0] in,
    output parity
);
    wire half_parity_0;
    wire half_parity_1;

    // XOR reduction on the lower 4 bits
    assign half_parity_0 = ^in[3:0];

    // XOR reduction on the upper 4 bits
    assign half_parity_1 = ^in[7:4];

    // Final parity is XOR of the two halves' parities
    assign parity = half_parity_0 ^ half_parity_1;

endmodule