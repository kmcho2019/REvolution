module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: only lower 3 bits matter (in[3] has no left neighbor)
    assign out_both = {1'bz, in[2:0] & in[3:1]};

    // out_any: only upper 3 bits matter (in[0] has no right neighbor)
    assign out_any = {in[3:1] | in[2:0], 1'bz};

    // out_different: efficient wrap-around using circular shift
    assign out_different = in ^ {in[0], in[3:1]};

endmodule