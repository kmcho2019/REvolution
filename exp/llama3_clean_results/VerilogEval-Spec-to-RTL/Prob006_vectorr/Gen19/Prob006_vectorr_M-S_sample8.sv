// Module to reverse the bit ordering of an 8-bit input using a direct assignment approach
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Directly assign the bits of the output vector in reverse order
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule