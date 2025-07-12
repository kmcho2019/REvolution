module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    assign out_both = { (in[99:1] & in[98:0]), 1'b0 };
    assign out_any  = { 1'b0, (in[99:1] | in[98:0]) };
    assign out_different = in ^ {in[0], in[99:1]};

endmodule