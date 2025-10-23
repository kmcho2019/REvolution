module TopModule (
    input  [7:0] in,
    output       parity
);

    wire parity_low;
    wire parity_high;

    // XOR reduction of lower 4 bits
    assign parity_low  = ^in[3:0];
    // XOR reduction of upper 4 bits
    assign parity_high = ^in[7:4];

    // final parity is XOR of two halves
    assign parity = parity_low ^ parity_high;

endmodule