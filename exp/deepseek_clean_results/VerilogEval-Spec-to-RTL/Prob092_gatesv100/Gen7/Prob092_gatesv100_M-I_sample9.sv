module TopModule (
    input [99:0] in,
    input en_both,
    input en_any,
    input en_diff,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

always @(*) begin
    // out_both: AND with left neighbor (bit 99 = 0)
    if (en_both) begin
        out_both = {1'b0, in[98:0] & in[99:1]};
    end else begin
        out_both = 100'b0;
    end
    
    // out_any: OR with right neighbor (bit 0 = 0)
    if (en_any) begin
        out_any = {in[99:1] | in[98:0], 1'b0};
    end else begin
        out_any = 100'b0;
    end
    
    // out_different: XOR with left neighbor (break circular path)
    if (en_diff) begin
        out_different[98:0] = in[98:0] ^ in[99:1];
        out_different[99] = in[99] ^ in[0];
    end else begin
        out_different = 100'b0;
    end
end

endmodule