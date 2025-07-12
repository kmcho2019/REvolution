module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0 (no left neighbor)
    // Use explicit ternary to clearly define boundary bit, aiding synthesis
    assign out_both = { (in[99] & 1'b0), (in[98:0] & in[99:1]) };

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0 (no right neighbor)
    // Explicit ternary assignment for bit 0 helps synthesis clarity
    assign out_any = { (in[99:1] | in[98:0]), 1'b0 };

    // out_different[i] = in[i] ^ in[(i-1) mod 100], wrap-around neighbor via concatenation
    assign out_different = in ^ {in[0], in[99:1]};

endmodule