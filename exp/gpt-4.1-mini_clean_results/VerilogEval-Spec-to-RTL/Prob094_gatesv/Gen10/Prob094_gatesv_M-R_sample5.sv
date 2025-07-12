module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

genvar i;

// out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0
generate
    for (i = 0; i < 3; i = i + 1) begin : GEN_OUT_BOTH
        assign out_both[i] = in[i] & in[i+1];
    end
endgenerate
assign out_both[3] = 1'b0;

// out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0
generate
    for (i = 1; i < 4; i = i + 1) begin : GEN_OUT_ANY
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate
assign out_any[0] = 1'b0;

// out_different[i] = in[i] ^ in[(i+1)%4], wrap-around handled by conditional
generate
    for (i = 0; i < 4; i = i + 1) begin : GEN_OUT_DIFFERENT
        if (i < 3)
            assign out_different[i] = in[i] ^ in[i+1];
        else // i == 3, wrap around to in[0]
            assign out_different[i] = in[3] ^ in[0];
    end
endgenerate

endmodule