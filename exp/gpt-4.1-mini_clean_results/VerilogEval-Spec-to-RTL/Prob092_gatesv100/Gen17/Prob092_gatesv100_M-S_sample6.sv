module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: 1 if in[i] and in[i+1] are both 1, for i=0..98; out_both[99]=0
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any[i]: 1 if in[i] or in[i-1] is 1, for i=1..99; out_any[0]=0
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different[i]: 1 if in[i] != in[left neighbor], with wrap-around
    // left neighbor of in[0] is in[99]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule