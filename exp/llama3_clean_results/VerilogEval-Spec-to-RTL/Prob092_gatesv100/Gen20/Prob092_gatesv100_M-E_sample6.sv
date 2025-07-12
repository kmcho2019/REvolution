module out_both_module(
    input [99:0] in,
    output [99:0] out
);

    assign out[99] = 1'b0;
    assign out[98:0] = in[98:0] & in[99:1];

endmodule

module out_any_module(
    input [99:0] in,
    output [99:0] out
);

    assign out[0] = 1'b0;
    assign out[99:1] = in[99:1] | in[98:0];

endmodule

module out_different_module(
    input [99:0] in,
    output [99:0] out
);

    assign out = in ^ {in[0], in[99:1]};

endmodule

module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    out_both_module both_module(.in(in), .out(out_both));
    out_any_module any_module(.in(in), .out(out_any));
    out_different_module different_module(.in(in), .out(out_different));

endmodule