module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized 3-bit population count
    // LSB: XOR of all bits (sum mod 2)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // MSB: Simplified majority function for 3 bits
    // Only need to check if any two bits are set (since 3 bits would also satisfy)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule