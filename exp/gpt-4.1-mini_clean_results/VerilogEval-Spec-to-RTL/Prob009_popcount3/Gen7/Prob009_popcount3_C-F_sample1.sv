module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Population count for 3-bit input: sum of bits
    // out[0] (LSB) = parity = in[0] ^ in[1] ^ in[2]
    // out[1] (MSB) = majority = (in[0]&in[1]) | (in[1]&in[2]) | (in[2]&in[0])
    assign out = in[0] + in[1] + in[2];

endmodule