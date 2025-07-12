module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = in & {in[3:1], 1'b0};
    assign out_any = in | {1'b0, in[3:1]};
    assign out_different = in ^ {in[0], in[3:1]};

endmodule