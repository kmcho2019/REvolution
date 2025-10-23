module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Intermediate terms for pairwise ANDs
    wire and01 = in[0] & in[1];
    wire and12 = in[1] & in[2];
    wire and02 = in[0] & in[2];
    
    // Output assignments
    assign out[0] = ^in;               // LSB: XOR of all bits (odd count)
    assign out[1] = and01 | and12 | and02;  // MSB: OR of pairwise ANDs (≥2 bits set)
endmodule