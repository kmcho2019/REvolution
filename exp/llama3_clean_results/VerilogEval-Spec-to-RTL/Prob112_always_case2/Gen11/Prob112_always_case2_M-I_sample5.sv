// Module for a 4-bit priority encoder
// Outputs the position of the first '1' bit in the input vector
// If no '1' bits are found, outputs 2'b00
module TopModule(
    input  [3:0] in, // 4-bit input vector
    output [1:0] pos // 2-bit output for position
);

// Continuous assignment to output the position of the first '1' bit
assign pos = (
    (in[3])? 2'b11 : // Most significant bit set
    (in[2])? 2'b10 : // Second most significant bit set
    (in[1])? 2'b01 : // Middle bit set
    (in[0])? 2'b00 : // Least significant bit set
    2'b00 // No bits set, output 00
);

endmodule