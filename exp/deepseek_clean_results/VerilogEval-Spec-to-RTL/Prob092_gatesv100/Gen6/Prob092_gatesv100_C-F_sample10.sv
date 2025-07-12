module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: check current and left neighbor (except MSB)
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: check current or right neighbor (except LSB)
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: XOR with left neighbor (wrap-around)
    wire [99:0] in_left_shifted = {in[0], in[99:1]};
    assign out_different = in ^ in_left_shifted;

endmodule