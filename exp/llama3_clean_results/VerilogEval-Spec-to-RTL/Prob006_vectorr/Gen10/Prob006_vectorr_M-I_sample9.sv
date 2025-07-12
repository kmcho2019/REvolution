// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  wire [7:0] in,  // 8-bit input vector
    output wire [7:0] out // 8-bit output vector
);
    // Use direct assignment for clarity and efficiency.
    // This assigns the bits of the input to the output in reverse order.
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    
    // Alternatively, a more concise way to express the reversal could be:
    // assign out = in[7:0];
    // However, this might not offer significant area savings and could potentially
    // complicate the synthesis process. The explicit assignment as above is more
    // straightforward and directly conveys the intended operation.
endmodule