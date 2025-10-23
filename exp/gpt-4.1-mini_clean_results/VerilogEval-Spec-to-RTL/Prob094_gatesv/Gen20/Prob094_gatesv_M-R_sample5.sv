module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    genvar i;

    // out_both: AND of in[i] and in[i+1] for i=0..2; bit 3 = 0
    generate
        for (i = 0; i < 3; i = i + 1) begin : GEN_OUT_BOTH
            assign out_both[i] = in[i] & in[i+1];
        end
        assign out_both[3] = 1'b0;
    endgenerate

    // out_any: OR of in[i] and in[i-1] for i=1..3; bit 0 = 0
    generate
        assign out_any[0] = 1'b0;
        for (i = 1; i < 4; i = i + 1) begin : GEN_OUT_ANY
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different: XOR of in[i] and in[(i+1)%4] with wrap-around for all i
    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_OUT_DIFF
            localparam next = (i + 1) % 4;
            assign out_different[i] = in[i] ^ in[next];
        end
    endgenerate

endmodule