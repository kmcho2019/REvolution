module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    genvar i;

    // out_both[i]: 1 if both in[i] and in[i+1] are 1, for i=0..2; out_both[3] = 0 (no neighbor)
    generate
        for (i = 0; i < 3; i = i + 1) begin : GEN_OUT_BOTH
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[3] = 1'b0;

    // out_any[i]: 1 if either in[i] or in[i-1] is 1, for i=1..3; out_any[0] = 0 (no neighbor)
    assign out_any[0] = 1'b0;
    generate
        for (i = 1; i < 4; i = i + 1) begin : GEN_OUT_ANY
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i]: 1 if in[i] != in[(i+1) mod 4]
    // fully vectorized with wrap-around indexing for minimal area and power
    assign out_different = in ^ {in[0], in[3:1]};

endmodule