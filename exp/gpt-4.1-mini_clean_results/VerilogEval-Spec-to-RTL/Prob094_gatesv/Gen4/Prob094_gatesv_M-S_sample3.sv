module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: bits 0..2 = in[i] & in[i+1], bit 3 = 0
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: bits 1..3 = in[i] | in[i-1], bit 0 = 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: in XOR rotated left by 1 (wrap-around)
    assign out_different = in ^ {in[2:0], in[3]};

endmodule