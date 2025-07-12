module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = ^in;  // LSB: XOR of all bits (odd count)
    assign out[1] = (in[0] & (in[1] | in[2])) | (in[1] & in[2]);  // Optimized MSB: ≥2 bits set
endmodule