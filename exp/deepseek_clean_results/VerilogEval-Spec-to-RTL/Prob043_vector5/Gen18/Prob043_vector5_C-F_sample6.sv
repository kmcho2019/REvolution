module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Generate all pairwise comparisons in structured groups
    wire [4:0] cmp_a = {a~^a, a~^b, a~^c, a~^d, a~^e};
    wire [4:0] cmp_b = {b~^a, b~^b, b~^c, b~^d, b~^e};
    wire [4:0] cmp_c = {c~^a, c~^b, c~^c, c~^d, c~^e};
    wire [4:0] cmp_d = {d~^a, d~^b, d~^c, d~^d, d~^e};
    wire [4:0] cmp_e = {e~^a, e~^b, e~^c, e~^d, e~^e};

    // Single concatenation for final output
    assign out = {cmp_a, cmp_b, cmp_c, cmp_d, cmp_e};

endmodule