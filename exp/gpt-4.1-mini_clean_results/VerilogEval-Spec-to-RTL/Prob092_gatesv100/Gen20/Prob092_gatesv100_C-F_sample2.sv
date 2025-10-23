module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;

    // Intermediate wires for bits 0 to 98 (and 1 to 99) for vector bits
    wire [98:0] out_both_mid;
    wire [98:0] out_any_mid;
    wire [98:0] out_different_mid;

    // Generate assignments for bits 0 to 98 for out_both and out_different
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_bits_0_to_98
            assign out_both_mid[i]      = in[i] & in[i+1];
            assign out_any_mid[i]       = in[i+1] | in[i];  // Will adjust final assignment below
            assign out_different_mid[i] = in[i] ^ in[i+1];
        end
    endgenerate

    // Assign out_both[0..98] and out_both[99]
    assign out_both[98:0] = out_both_mid;
    assign out_both[99]   = 1'b0; // MSB no neighbor on left

    // Assign out_any[1..99] using out_any_mid[0..98], and out_any[0] = 0
    // Note: out_any[i] = in[i] | in[i-1], so for i=1..99:
    // out_any[i] = out_any_mid[i-1] from above because out_any_mid[i-1] = in[i] | in[i-1]
    assign out_any[99:1] = out_any_mid;
    assign out_any[0] = 1'b0; // LSB no neighbor on right

    // Assign out_different[0..98] from out_different_mid and out_different[99] with wrap-around
    assign out_different[98:0] = out_different_mid;
    assign out_different[99]   = in[99] ^ in[0];

endmodule