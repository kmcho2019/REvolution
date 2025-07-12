// Module that computes 4-input AND, OR, and XOR together using balanced 2-input trees with shared intermediate signals
module FourInputGatesShared (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Balanced two-level tree partial results for AND
    wire and_level1_0 = &in[1:0];  // AND of lower two bits
    wire and_level1_1 = &in[3:2];  // AND of upper two bits
    assign out_and = and_level1_0 & and_level1_1;

    // Balanced two-level tree partial results for OR
    wire or_level1_0 = |in[1:0];   // OR of lower two bits
    wire or_level1_1 = |in[3:2];   // OR of upper two bits
    assign out_or = or_level1_0 | or_level1_1;

    // Balanced two-level tree partial results for XOR
    wire xor_level1_0 = ^in[1:0];  // XOR of lower two bits
    wire xor_level1_1 = ^in[3:2];  // XOR of upper two bits
    assign out_xor = xor_level1_0 ^ xor_level1_1;
endmodulе

// Top-level module instantiates the shared 4-input gates module
module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    FourInputGatesShared u_shared (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
endmodule