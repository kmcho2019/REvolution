module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Hybrid implementation combining best of both approaches
    // LSB: XOR of all bits (efficient single-bit parity)
    // MSB: OR-of-ANDs (direct majority detection)
    assign out = {
        (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]),  // MSB
        in[0] ^ in[1] ^ in[2]                                   // LSB
    };

endmodule