module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND current bit with left neighbor (shift right)
    // Mask bit 3 since it has no left neighbor
    assign out_both = (in & {in[2:0], 1'b0}) & 4'b0111;

    // out_any: OR current bit with right neighbor (shift left)
    // Mask bit 0 since it has no right neighbor
    assign out_any = (in | {1'b0, in[3:1]}) & 4'b1110;

    // out_different: XOR current bit with left neighbor (circular shift right)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule