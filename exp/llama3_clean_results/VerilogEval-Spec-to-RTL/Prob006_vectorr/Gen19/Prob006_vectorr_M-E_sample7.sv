// Module to reverse the bit ordering of an 8-bit input using a circular shift register
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a continuous assignment to reverse the bits
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule