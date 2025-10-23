module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// 1. out_both: AND each bit with its left neighbor (except bit 99 which has none)
assign out_both = { (in[98:0] & in[99:1]), 1'b0 };

// 2. out_any: OR each bit with its right neighbor (except bit 0 which has none)
assign out_any = { 1'b0, (in[99:1] | in[98:0]) };

// 3. out_different: XOR each bit with its left neighbor (wrap-around)
wire [99:0] in_rotated_left = { in[98:0], in[99] };
assign out_different = in ^ in_rotated_left;

endmodule