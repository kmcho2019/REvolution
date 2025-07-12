module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: current bit AND left neighbor (except MSB)
    assign out_both[99] = 1'b0;  // Special case for MSB
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: current bit OR right neighbor (except LSB)
    assign out_any[0] = 1'b0;    // Special case for LSB
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: current bit XOR left neighbor (with wrap-around)
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule