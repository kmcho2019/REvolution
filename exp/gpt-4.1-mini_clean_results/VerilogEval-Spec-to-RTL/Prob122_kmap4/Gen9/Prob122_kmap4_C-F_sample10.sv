module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute parity of first pair (a and b) using reduction XOR
    wire ab_parity = ^{a, b};

    // Compute parity of second pair (c and d) using reduction XOR
    wire cd_parity = ^{c, d};

    // Final output is the XOR of the two intermediate parities,
    // representing parity of all four inputs.
    assign out = ab_parity ^ cd_parity;
endmodule