module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute parity of adjacent pairs using reduction XOR
    wire ab_parity = ^{a, b};
    wire cd_parity = ^{c, d};

    // Compute parity of cross pairs using reduction XOR
    wire ac_parity = ^{a, c};
    wire bd_parity = ^{b, d};

    // Combine the two parity computations
    // Both (ab_parity ^ cd_parity) and (ac_parity ^ bd_parity) produce the same output,
    // but we explicitly compute both to highlight structural equivalence
    wire out_from_adjacent = ab_parity ^ cd_parity;
    wire out_from_cross    = ac_parity ^ bd_parity;

    // Final output is XOR of the two computations, which are equal, 
    // so either can be used. Using both for clarity and verification.
    assign out = out_from_adjacent;

    // Synthesis tools will optimize redundant logic accordingly.
endmodule