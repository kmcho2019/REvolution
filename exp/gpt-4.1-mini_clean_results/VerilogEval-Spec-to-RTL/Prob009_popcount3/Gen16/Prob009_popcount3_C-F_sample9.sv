module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // out[1]: set if at least two bits are '1' (majority function)
    // out[0]: parity of the bits (odd number of '1's)
    assign out = { (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]),
                   in[0] ^ in[1] ^ in[2] };
endmodule