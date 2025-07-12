module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (in[3] is don't-care)
    assign out_both[2:0] = in[2:0] & in[3:1];

    // out_any: check current bit or right neighbor (in[0] is don't-care)
    assign out_any[3:1] = in[3:1] | in[2:0];

    // out_different: check current bit vs left neighbor with wrap-around
    assign out_different = in ^ {in[0], in[3:1]};

endmodule