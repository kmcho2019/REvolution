module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // For out_both: bits 0-2 = in[i] & in[i+1], bit 3 = 0
    wire [3:1] in_high = in[3:1];
    wire [2:0] in_low  = in[2:0];
    assign out_both[2:0] = in_low & in_high;
    assign out_both[3]   = 1'b0;

    // For out_any: bits 1-3 = in[i] | in[i-1], bit 0 = 0
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0]   = 1'b0;

    // For out_different: XOR of in with left circular shift of in by 1
    assign out_different = in ^ {in[2:0], in[3]};

endmodule