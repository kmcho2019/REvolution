module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // out[0] is XOR of all bits (odd parity)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // out[1] is 1 when two or three bits are set
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
endmodule