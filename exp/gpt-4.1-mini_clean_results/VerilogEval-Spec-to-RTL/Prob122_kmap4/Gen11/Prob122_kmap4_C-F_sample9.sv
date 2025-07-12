module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute XOR of inputs a and b using reduction XOR for conciseness
    wire ab_xor = ^{a, b};

    // Compute XOR of inputs c and d similarly
    wire cd_xor = ^{c, d};

    // Final output is XOR of the two intermediate XOR results, equivalent to XOR of all four inputs
    assign out = ab_xor ^ cd_xor;
endmodule