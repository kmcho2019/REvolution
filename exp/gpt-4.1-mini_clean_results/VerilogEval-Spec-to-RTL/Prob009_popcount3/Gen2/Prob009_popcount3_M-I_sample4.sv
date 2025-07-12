module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // out[0] = odd number of 1s (parity)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // out[1] = at least two bits set
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule