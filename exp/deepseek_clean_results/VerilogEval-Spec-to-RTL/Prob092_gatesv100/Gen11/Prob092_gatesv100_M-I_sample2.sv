module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different,
    input en_both,
    input en_any,
    input en_diff
);

wire [98:0] both_mid = in[98:0] & in[99:1];
wire [98:0] any_mid = in[99:1] | in[98:0];
wire [98:0] diff_mid = in[98:0] ^ in[99:1];

always @(*) begin
    // out_both: AND with left neighbor (bit 99 = 0)
    out_both = en_both ? {1'b0, both_mid} : 100'b0;
    
    // out_any: OR with right neighbor (bit 0 = 0)
    out_any = en_any ? {any_mid, 1'b0} : 100'b0;
    
    // out_different: XOR with left neighbor (split computation)
    out_different = en_diff ? {diff_mid, in[99] ^ in[0]} : 100'b0;
end

endmodule