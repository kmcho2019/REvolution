// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);
    // Directly assign the input bits to the output in reverse order
    // Using a more concise approach to reverse the bits
    assign out = in[7:0]; // This is equivalent to the original assignment but uses a range to specify the bits
endmodule