module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // LSB: XOR chain (odd parity) - from Example 2
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // MSB: Majority function (adder carry-out equivalent) - optimized from both examples
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule