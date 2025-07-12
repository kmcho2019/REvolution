module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create rotated version of input for wrap-around comparisons
    wire [99:0] in_rotated = {in[0], in[99:1]};

    // out_both: current bit AND left neighbor (except MSB which is 0)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: current bit OR right neighbor (except LSB which is 0)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: XOR with rotated (left neighbor with wrap-around)
    assign out_different = in ^ in_rotated;

endmodule