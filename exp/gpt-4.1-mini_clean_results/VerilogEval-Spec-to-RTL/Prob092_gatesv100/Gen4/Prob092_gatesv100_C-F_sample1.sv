module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0 (no left neighbor)
    assign out_both[98:0] = in[98:0] & in[99:1];

    genvar i;
    generate
        // Explicitly assign boundary bit out_both[99] = 0
        assign out_both[99] = 1'b0;
    endgenerate

    // out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0 (no right neighbor)
    assign out_any[99:1] = in[99:1] | in[98:0];

    generate
        // Explicitly assign boundary bit out_any[0] = 0
        assign out_any[0] = 1'b0;
    endgenerate

    // out_different[i] = in[i] ^ in[(i+1) mod 100] with wrap-around neighbor
    // Use concatenation to rotate 'in' by one bit for wrap-around XOR
    assign out_different = in ^ {in[0], in[99:1]};

endmodule