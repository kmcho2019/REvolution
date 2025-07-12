module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: current AND left (MSB always 0)
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: current OR right (LSB always 0)
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: current XOR left (with wrap-around)
    assign out_different[99] = in[99] ^ in[0];
    assign out_different[98:0] = in[98:0] ^ in[99:1];

endmodule