// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);
    // Use direct assignment for clarity and efficiency.
    // This assigns the bits of the input to the output in reverse order.
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, for larger vectors or more complex operations, 
    // an always block with a loop could be used, but for an 8-bit vector,
    // the direct assignment is more straightforward and likely more efficient.
endmodule