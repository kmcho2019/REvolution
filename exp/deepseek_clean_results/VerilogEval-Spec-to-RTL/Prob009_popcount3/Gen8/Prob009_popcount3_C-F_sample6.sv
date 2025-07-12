module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Fused solution: direct sum with decomposed logic
    assign out = { (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]),  // Carry (MSB)
                   in[0] ^ in[1] ^ in[2] };                               // Sum (LSB)
endmodule