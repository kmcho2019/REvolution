module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[98:0] = in[98:0] & in[99:1]; out_both[99] = 0
    assign out_both = {1'b0, (in[98:0] & in[99:1])};

    // out_any[99:1] = in[99:1] | in[98:0]; out_any[0] = 0
    assign out_any = {(in[99:1] | in[98:0]), 1'b0};

    // out_different = in ^ {in[0], in[99:1]} (wrap-around XOR)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule