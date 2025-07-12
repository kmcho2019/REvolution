module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);
    // out_both[i] = in[i] & in[i+1], except for i=99 which is 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1], except for i=0 which is 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    assign out_different[98:0] = in[98:0] ^ in[99:1];
    assign out_different[99] = in[99] ^ in[0];
endmodule