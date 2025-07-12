module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor0, xor1, xor2, xor3, xor4, xor5, xor6;

    assign xor0 = in[0] ^ in[1];
    assign xor1 = xor0 ^ in[2];
    assign xor2 = xor1 ^ in[3];
    assign xor3 = xor2 ^ in[4];
    assign xor4 = xor3 ^ in[5];
    assign xor5 = xor4 ^ in[6];
    assign xor6 = xor5 ^ in[7];

    assign parity = xor6;
endmodule