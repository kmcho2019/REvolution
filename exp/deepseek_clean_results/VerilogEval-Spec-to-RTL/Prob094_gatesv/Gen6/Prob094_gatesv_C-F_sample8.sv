module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: bits 2:0 check current and left neighbor, bit 3 always 0
    assign out_both = {1'b0, in[3:1] & in[2:0]};
    
    // out_any: bits 3:1 check current or right neighbor, bit 0 always 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};
    
    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule