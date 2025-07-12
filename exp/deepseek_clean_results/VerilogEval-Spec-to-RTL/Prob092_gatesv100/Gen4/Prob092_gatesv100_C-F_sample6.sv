module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: check current and left neighbor (except MSB)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: check current or right neighbor (except LSB)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: wrap-around XOR using circular shift
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule