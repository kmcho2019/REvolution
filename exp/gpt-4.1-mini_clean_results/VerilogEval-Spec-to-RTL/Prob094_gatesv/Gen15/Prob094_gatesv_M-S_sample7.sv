module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: bitwise AND of in and in shifted left by 1; last bit zeroed
    assign out_both = (in & (in << 1)) & 4'b0111;

    // out_any: bitwise OR of in and in shifted right by 1; first bit zeroed
    assign out_any = (in | (in >> 1)) & 4'b1110;

    // out_different: XOR of in and in rotated left by 1
    assign out_different = in ^ {in[2:0], in[3]};

endmodule