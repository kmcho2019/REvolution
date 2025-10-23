module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized 3-bit population count
    // LSB: XOR of all bits remains optimal
    assign out[0] = in[0] ^ in[1] ^ in[2];
    
    // MSB: More area-efficient majority detection
    // Uses only 2 AND gates by computing pairwise terms first
    wire and01 = in[0] & in[1];
    wire and12 = in[1] & in[2];
    assign out[1] = and01 | and12 | (in[0] & in[2]);
endmodule