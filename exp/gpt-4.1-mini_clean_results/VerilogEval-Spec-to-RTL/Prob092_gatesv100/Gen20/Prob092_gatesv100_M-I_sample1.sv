module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);
    genvar i;

    // out_both[i]: 1 if both in[i] and left neighbor in[i+1] are 1 (for i=0..98)
    // out_both[99] = 0 as no left neighbor for bit 99
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
        assign out_both[99] = 1'b0;
    endgenerate

    // out_any[i]: 1 if in[i] or right neighbor in[i-1] are 1 (for i=1..99)
    // out_any[0] = 0 as no right neighbor for bit 0
    generate
        assign out_any[0] = 1'b0;
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i]: 1 if in[i] differs from left neighbor with wrap-around
    // Left neighbor index is (i + 1) mod 100 to implement wrap-around
    generate
        for (i = 0; i < 100; i = i + 1) begin : gen_out_diff
            // neighbor index is (i+1) mod 100
            wire neighbor = in[(i == 99) ? 0 : (i + 1)];
            assign out_different[i] = in[i] ^ neighbor;
        end
    endgenerate

endmodule