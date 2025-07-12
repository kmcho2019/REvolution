module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Count the number of 1's in 'in' using combinational logic
    // out[0] = 1 if odd number of bits are set (parity)
    // out[1] = 1 if at least two bits are set
    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);

endmodule