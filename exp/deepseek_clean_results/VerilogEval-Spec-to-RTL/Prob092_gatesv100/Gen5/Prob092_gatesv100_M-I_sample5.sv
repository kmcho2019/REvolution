module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different,
    input en_both,    // Enable for out_both
    input en_any,     // Enable for out_any
    input en_diff     // Enable for out_different
);

wire [98:0] left_and = in[98:0] & in[99:1];
wire [98:0] right_or = in[99:1] | in[98:0];
wire [98:0] diff_normal = in[98:0] ^ in[99:1];

always @(*) begin
    // out_both: AND with left neighbor (bit 99 = 0)
    out_both = en_both ? {1'b0, left_and} : 100'b0;
    
    // out_any: OR with right neighbor (bit 0 = 0)
    out_any = en_any ? {right_or, 1'b0} : 100'b0;
    
    // out_different: XOR with left neighbor (bit 99 special case)
    out_different = en_diff ? {diff_normal, in[99] ^ in[0]} : 100'b0;
end

endmodule