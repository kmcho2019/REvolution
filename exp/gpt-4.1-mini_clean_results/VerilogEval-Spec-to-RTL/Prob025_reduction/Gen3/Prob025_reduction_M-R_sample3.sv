module TopModule (
    input  [7:0] in,
    output       parity
);

    wire half_parity_0;
    wire half_parity_1;

    // Compute parity for lower 4 bits
    assign half_parity_0 = ^in[3:0];
    // Compute parity for upper 4 bits
    assign half_parity_1 = ^in[7:4];

    // Final parity is XOR of the two half parities
    assign parity = half_parity_0 ^ half_parity_1;

endmodule