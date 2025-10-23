module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

genvar i;

// out_both: out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3]=0
generate
    for (i=0; i<3; i=i+1) begin : GEN_OUT_BOTH
        assign out_both[i] = in[i] & in[i+1];
    end
endgenerate
assign out_both[3] = 1'b0;

// out_any: out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0]=0
generate
    for (i=1; i<4; i=i+1) begin : GEN_OUT_ANY
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate
assign out_any[0] = 1'b0;

// out_different: out_different[i] = in[i] ^ in[left neighbor], with wrap-around
generate
    for (i=0; i<4; i=i+1) begin : GEN_OUT_DIFF
        // left neighbor wraps: (i+1) mod 4
        assign out_different[i] = in[i] ^ in[(i+1) % 4];
    end
endgenerate

endmodule