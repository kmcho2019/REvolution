module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: check current bit and left neighbor (except MSB)
    wire [98:0] both_middle = in[98:0] & in[99:1];
    assign out_both = {1'b0, both_middle};

    // out_any: check current bit and right neighbor (except LSB)
    wire [98:0] any_middle = in[99:1] | in[98:0];
    assign out_any = {any_middle, 1'b0};

    // out_different: XOR with left neighbor (with wrap-around)
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule