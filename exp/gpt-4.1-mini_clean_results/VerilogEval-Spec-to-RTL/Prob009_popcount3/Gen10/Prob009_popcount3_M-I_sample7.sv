module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire xor01;

    // Compute XOR of first two bits once
    assign xor01 = in[0] ^ in[1];

    // out[0]: parity of all three bits
    assign out[0] = xor01 ^ in[2];

    // out[1]: two or more ones
    assign out[1] = (in[0] & in[1]) | (xor01 & in[2]);

endmodule