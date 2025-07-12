module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // out[0]: parity of input bits
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // out[1]: majority (at least two ones)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule