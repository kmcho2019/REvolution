module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire bit0_xor;
    wire bit1_and_2;
    wire bit0_and_1;
    wire bit0_and_2;

    // LSB of count: parity of inputs (odd number of ones)
    assign bit0_xor = in[0] ^ in[1] ^ in[2];

    // MSB of count: majority function (at least two 1s)
    assign bit1_and_2 = in[1] & in[2];
    assign bit0_and_1 = in[0] & in[1];
    assign bit0_and_2 = in[0] & in[2];
    assign out[1] = bit1_and_2 | bit0_and_1 | bit0_and_2;

    assign out[0] = bit0_xor;
endmodule