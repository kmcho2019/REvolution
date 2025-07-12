module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire bit0 = in[0];
    wire bit1 = in[1];
    wire bit2 = in[2];

    // LSB is odd parity (XOR of all bits)
    wire lsb = bit0 ^ bit1 ^ bit2;

    // MSB is 1 if at least two bits are 1 (majority)
    wire msb = (bit0 & bit1) | (bit1 & bit2) | (bit0 & bit2);

    assign out = {msb, lsb};

endmodule