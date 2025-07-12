module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: bit-wise AND with left-shifted input, mask MSB
    assign out_both = (in & {in[2:0], 1'b0}) & 4'b0111;

    // out_any: bit-wise OR with right-shifted input, mask LSB
    assign out_any = (in | {1'b0, in[3:1]}) & 4'b1110;

    // out_different: direct circular XOR without intermediate wire
    assign out_different = in ^ {in[0], in[3:1]};

endmodule