module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND of each bit with left neighbor (ignore MSB)
    assign out_both = {1'bx, in[2:0] & in[3:1]};

    // out_any: OR of each bit with right neighbor (ignore LSB)
    assign out_any = {in[3:1] | in[2:0], 1'bx};

    // out_different: XOR of each bit with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule