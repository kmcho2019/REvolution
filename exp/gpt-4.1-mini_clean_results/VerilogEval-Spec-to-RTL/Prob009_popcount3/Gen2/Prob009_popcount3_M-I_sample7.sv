module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0]: parity (XOR) of the three bits => number of ones mod 2
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1]: majority function (at least two bits are 1)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule