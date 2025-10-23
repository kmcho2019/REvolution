module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except for in[3])
    assign out_both[2:0] = in[3:1] & in[2:0];
    assign out_both[3] = 1'b0;  // don't care, but set to 0 for completeness

    // out_any: check current bit and right neighbor (except for in[0])
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // don't care, but set to 0 for completeness

    // out_different: check current bit and left neighbor with wrap-around
    assign out_different = in ^ {in[0], in[3:1]};

endmodule