// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Reverse the bit ordering of the input and assign it to the output
    assign out = in[7:0]; // This will reverse the bits by using the same range but assigning in reverse order

endmodule