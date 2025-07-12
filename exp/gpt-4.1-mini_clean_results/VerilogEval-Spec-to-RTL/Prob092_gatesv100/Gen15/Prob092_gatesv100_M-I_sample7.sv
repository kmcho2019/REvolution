module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // For out_both[0:98], AND of in[i] and in[i+1]
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0; // no left neighbor for bit 99

    // For out_any[1:99], OR of in[i] and in[i-1]
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0; // no right neighbor for bit 0

    // For out_different, wrap around: XOR each bit with its left neighbor,
    // with in[99]'s left neighbor as in[0]
    wire [99:0] in_rotated_left = {in[0], in[99:1]};
    assign out_different = in ^ in_rotated_left;

endmodule