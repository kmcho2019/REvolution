module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND current bit with left neighbor (bits 2:0 only)
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;  // MSB not needed per spec

    // out_any: OR current bit with right neighbor (bits 3:1 only)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // LSB not needed per spec

    // out_different: XOR with left neighbor (wrap-around)
    wire [3:0] left_neighbor = {in[0], in[3:1]};
    assign out_different = in ^ left_neighbor;

endmodule