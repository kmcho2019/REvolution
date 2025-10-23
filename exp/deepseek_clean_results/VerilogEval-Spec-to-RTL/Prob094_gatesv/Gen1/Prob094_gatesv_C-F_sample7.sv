module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit AND left neighbor (ignore out_both[3])
    assign out_both[2:0] = in[2:0] & in[3:1];

    // out_any: check current bit OR right neighbor (ignore out_any[0])
    assign out_any[3:1] = in[3:1] | in[2:0];

    // out_different: elegant wrap-around using concatenation
    assign out_different = in ^ {in[0], in[3:1]};

endmodule