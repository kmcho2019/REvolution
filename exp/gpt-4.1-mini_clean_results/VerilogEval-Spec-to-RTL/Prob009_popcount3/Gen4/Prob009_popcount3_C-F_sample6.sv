module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate wires for population count bits
    wire lsb; // parity (XOR of all bits)
    wire msb; // majority (at least two bits set)

    assign lsb = in[0] ^ in[1] ^ in[2];
    assign msb = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    assign out = {msb, lsb};

endmodule