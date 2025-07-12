module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

always @(*) begin
    // out_both: AND with left neighbor (bit 99 = 0)
    out_both = {1'b0, in[98:0] & in[99:1]};
    
    // out_any: OR with right neighbor (bit 0 = 0)
    out_any = {in[99:1] | in[98:0], 1'b0};
    
    // out_different: XOR with left neighbor (wrap-around)
    out_different = in ^ {in[0], in[99:1]};
end

endmodule