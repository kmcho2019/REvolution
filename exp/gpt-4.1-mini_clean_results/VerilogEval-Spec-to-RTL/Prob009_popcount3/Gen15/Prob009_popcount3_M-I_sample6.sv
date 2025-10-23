module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // out[1] is set if at least two bits are '1' (majority)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
    // out[0] is parity of the input bits (odd number of '1's)
    assign out[0] = in[0] ^ in[1] ^ in[2];
endmodule