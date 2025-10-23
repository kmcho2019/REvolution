module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // LSB: parity (number of ones mod 2)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // MSB: majority (at least two ones)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule