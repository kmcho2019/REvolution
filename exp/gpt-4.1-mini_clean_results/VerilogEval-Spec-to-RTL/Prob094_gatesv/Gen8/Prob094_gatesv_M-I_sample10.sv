module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: bits 0-2 = in[i] & in[i+1], bit 3 = 0
    assign out_both = { (in[2:0] & in[3:1]), 1'b0 };

    // out_any: bit 0 = 0, bits 1-3 = in[i] | in[i-1]
    assign out_any = { (in[3:1] | in[2:0]), 1'b0 };

    // out_different: out_different[i] = in[i] ^ in[(i+1)%4]
    // Rotate 'in' left by 1 to get neighbor to left with wrap-around
    wire [3:0] in_rot = {in[2:0], in[3]};
    assign out_different = in ^ in_rot;

endmodule