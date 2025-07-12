module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shifted versions of input for cleaner neighbor access
    wire [99:0] left_neighbor = {in[0], in[99:1]};  // Circular left shift
    wire [99:0] right_neighbor = {in[98:0], 1'b0};   // Right shift with 0 pad

    // out_both: AND with left neighbor (except MSB)
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: OR with right neighbor (except LSB)
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ left_neighbor;

endmodule