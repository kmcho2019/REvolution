module TopModule(
    input  [3:0] in,
    output wire  out_and,
    output wire  out_or,
    output wire  out_xor
);

    // Intermediate pairwise computations to encourage gate sharing
    wire and_high = in[3] & in[2];
    wire and_low  = in[1] & in[0];
    wire or_high  = in[3] | in[2];
    wire or_low   = in[1] | in[0];
    wire xor_high = in[3] ^ in[2];
    wire xor_low  = in[1] ^ in[0];

    // Final outputs using intermediate signals
    assign out_and = and_high & and_low;
    assign out_or  = or_high  | or_low;
    assign out_xor = xor_high ^ xor_low;

endmodule