module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular view of input (for out_different)
    wire [3:0] left_neighbor = {in[0], in[3:1]};

    // out_both: AND with left neighbor (ignore MSB)
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;  // Don't care

    // out_any: OR with right neighbor (ignore LSB)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // Don't care

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ left_neighbor;

endmodule