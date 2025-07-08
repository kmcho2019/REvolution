module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[0 to 98] = in[i] & in[i+1], out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[1 to 99] = in[i] | in[i-1], out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    assign out_different = in ^ {in[98:0], in[99]};

endmodule