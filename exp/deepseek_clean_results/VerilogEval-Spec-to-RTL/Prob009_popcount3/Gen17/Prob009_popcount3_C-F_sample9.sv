module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // LSB is sum modulo 2 (XOR of all bits)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // MSB is majority function (at least two 1's)
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
endmodule