module TopModule (
    input  [7:0] in,
    output       parity
);

    wire parity_low  = ^in[3:0];  // XOR reduction on lower half
    wire parity_high = ^in[7:4];  // XOR reduction on upper half

    assign parity = parity_low ^ parity_high; // XOR halves for final parity

endmodule