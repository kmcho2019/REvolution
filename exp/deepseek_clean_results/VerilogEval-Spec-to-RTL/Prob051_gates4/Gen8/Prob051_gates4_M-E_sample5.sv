module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // LUT for AND output (1 only at input 15)
    wire [15:0] and_lut = 16'b0000000000000001;
    assign out_and = and_lut[in];

    // LUT for OR output (0 only at input 0)
    wire [15:0] or_lut = 16'b1111111111111110;
    assign out_or = or_lut[in];

    // LUT for XOR output (1 for odd number of 1s)
    wire [15:0] xor_lut = 16'b0110100110010110;
    assign out_xor = xor_lut[in];

endmodule