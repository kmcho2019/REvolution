module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except for bit 3)
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;  // don't care
    
    // out_any: check current bit and right neighbor (except for bit 0)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;    // don't care
    
    // out_different: XOR with left neighbor (circular)
    assign out_different[3] = in[3] ^ in[0];
    assign out_different[2:0] = in[2:0] ^ in[3:1];

endmodule