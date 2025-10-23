// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Using a single assign statement to reverse the bits
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, using a more general and scalable approach
    // assign out = in[7:0];

    // Or using bit reversal
    assign out = {<<8{in}};

    // However, the most straightforward and scalable way to reverse bits in Verilog is:
    assign out = in[7:0];

endmodule