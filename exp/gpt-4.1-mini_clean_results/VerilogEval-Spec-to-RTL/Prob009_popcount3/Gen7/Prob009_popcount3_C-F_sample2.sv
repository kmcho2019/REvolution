module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Least significant bit (LSB) is parity: XOR of all bits
    wire lsb = in[0] ^ in[1] ^ in[2];
    // Most significant bit (MSB) is majority: at least two bits set
    wire msb = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    assign out = {msb, lsb};

endmodule