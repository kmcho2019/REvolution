module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Rotated version of input for wrap-around comparison
    wire [3:0] in_rotated = {in[0], in[3:1]};

    // out_both: AND with left neighbor
    assign out_both[3] = 1'b0;  // No neighbor to left
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];

    // out_any: OR with right neighbor
    assign out_any[3] = in[3] | in[2];
    assign out_any[2] = in[2] | in[1];
    assign out_any[1] = in[1] | in[0];
    assign out_any[0] = 1'b0;    // No neighbor to right

    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ in_rotated;

endmodule