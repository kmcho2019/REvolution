module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = ^in;                      // LSB: odd count
    assign out[1] = (in[0] & in[1]) |        // MSB: ≥2 bits set
                   (in[0] & in[2]);          // Only need to check two pairs
endmodule